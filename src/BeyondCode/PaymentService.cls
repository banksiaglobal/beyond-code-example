Class BeyondCode.PaymentService
{

ClassMethod CreateOrder(pAmount, Output pOrder As %DynamicObject, Output pError As %String) As %Boolean
{
    set pOrder = ""
    set pError = ""
    if (pAmount'?1.N) || (pAmount'>0) {
        set pError = "amount must be a positive integer in cents"
        quit 0
    }

    set order = ##class(BeyondCode.OrderRecord).%New()
    set order.Amount = pAmount
    set order.Status = "pending_payment"
    set sc = order.%Save()
    if $$$ISERR(sc) {
        set pError = $system.Status.GetErrorText(sc)
        quit 0
    }

    set pOrder = ..OrderJSON(order)
    quit 1
}

ClassMethod GetOrder(pOrderId, Output pOrder As %DynamicObject) As %Boolean
{
    set pOrder = ""
    set order = ##class(BeyondCode.OrderRecord).%OpenId(pOrderId)
    if '$isobject(order) quit 0
    set pOrder = ..OrderJSON(order)
    quit 1
}

ClassMethod PayOrder(pOrderId, Output pResult As %DynamicObject, Output pError As %String) As %Boolean
{
    set pResult = ""
    set pError = ""
    set order = ##class(BeyondCode.OrderRecord).%OpenId(pOrderId)
    if '$isobject(order) {
        set pError = "order not found"
        quit 0
    }
    if order.Status = "paid" {
        set pError = "order is already paid"
        quit 0
    }

    set charge = ##class(BeyondCode.PaymentGatewaySimulator).RequestCharge(order.%Id(), order.Amount)
    if charge.status = "timeout" {
        set pError = charge.error
        quit 0
    }

    set payment = ##class(BeyondCode.PaymentRecord).%New()
    set payment.Order = order
    set payment.Amount = order.Amount
    set payment.Status = charge.status
    set payment.ProviderPaymentId = charge.provider_payment_id
    set sc = payment.%Save()
    if $$$ISERR(sc) {
        set pError = $system.Status.GetErrorText(sc)
        quit 0
    }

    if '..ConfirmPayment(charge.confirmation.provider_payment_id, charge.confirmation.status, .confirmedPayment, .pError) quit 0

    set pResult = {}
    set pResult.order = ..OrderJSON(order)
    set pResult.payment = confirmedPayment
    quit 1
}

ClassMethod ConfirmPayment(pProviderPaymentId As %String, pStatus As %String, Output pPayment As %DynamicObject, Output pError As %String) As %Boolean
{
    set pPayment = ""
    set pError = ""
    if (pProviderPaymentId = "") || (pStatus '= "succeeded") {
        set pError = "a successful payment confirmation is required"
        quit 0
    }

    set result = ##class(%SQL.Statement).%ExecDirect(, "SELECT TOP 1 ID FROM BeyondCode.PaymentRecord WHERE ProviderPaymentId = ? ORDER BY ID DESC", pProviderPaymentId)
    if (result.%SQLCODE < 0) {
        set pError = result.%Message
        quit 0
    }
    if 'result.%Next() {
        set pError = "payment not found"
        quit 0
    }

    set payment = ##class(BeyondCode.PaymentRecord).%OpenId(result.%Get("ID"))
    set payment.Status = "succeeded"
    set payment.Order.Status = "paid"
    set sc = payment.%Save()
    if $$$ISERR(sc) {
        set pError = $system.Status.GetErrorText(sc)
        quit 0
    }

    set pPayment = ..PaymentJSON(payment)
    quit 1
}

ClassMethod Reset() As %Status
{
    set sc = ##class(BeyondCode.PaymentRecord).%DeleteExtent()
    quit:$$$ISERR(sc) sc
    quit ##class(BeyondCode.OrderRecord).%DeleteExtent()
}

ClassMethod OrderJSON(pOrder As BeyondCode.OrderRecord) As %DynamicObject [ Private ]
{
    set result = {}
    set result.id = pOrder.%Id()
    set result.amount = pOrder.Amount
    set result.status = pOrder.Status
    quit result
}

ClassMethod PaymentJSON(pPayment As BeyondCode.PaymentRecord) As %DynamicObject [ Private ]
{
    set result = {}
    set result.id = pPayment.%Id()
    set result.order_id = pPayment.Order.%Id()
    set result.amount = pPayment.Amount
    set result.status = pPayment.Status
    set result.provider_payment_id = pPayment.ProviderPaymentId
    quit result
}

}
