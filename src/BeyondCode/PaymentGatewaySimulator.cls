Class BeyondCode.PaymentGatewaySimulator
{

ClassMethod RequestCharge(pOrderId As %Integer, pAmount As %Integer) As %DynamicObject
{
    set providerPaymentId = "pay_"_$translate($system.Util.CreateGUID(), "-{}", "")
    set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "amount") = pAmount
    set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "status") = "accepted"

    if ..GetBehaviour() = "timeout_after_acceptance" {
        set charge = {}
        set charge.status = "timeout"
        set charge.error = "payment provider timed out after accepting the charge; outcome is unknown"
        quit charge
    }

    set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "status") = "succeeded"
    set confirmation = {}
    set confirmation.provider_payment_id = providerPaymentId
    set confirmation.status = "succeeded"

    set charge = {}
    set charge.provider_payment_id = providerPaymentId
    set charge.status = "accepted"
    set charge.confirmation = confirmation
    quit charge
}

ClassMethod SetBehaviour(pBehaviour As %String = "normal")
{
    set ^BeyondCodePaymentGateway("behaviour") = pBehaviour
}

ClassMethod GetBehaviour() As %String
{
    set behaviour = $get(^BeyondCodePaymentGateway("behaviour"))
    quit $select(behaviour="":"normal", 1:behaviour)
}

ClassMethod GetChargesForOrder(pOrderId As %Integer) As %DynamicArray
{
    set charges = []
    set providerPaymentId = ""
    for  {
        set providerPaymentId = $order(^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId))
        quit:providerPaymentId=""

        set charge = {}
        set charge.provider_payment_id = providerPaymentId
        set charge.order_id = pOrderId
        set charge.amount = ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "amount")
        set charge.status = ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "status")
        do charges.%Push(charge)
    }
    quit charges
}

ClassMethod CountChargesForOrder(pOrderId As %Integer) As %Integer
{
    set charges = ..GetChargesForOrder(pOrderId)
    quit charges.%Size()
}

ClassMethod Reset()
{
    kill ^BeyondCodePaymentGateway
}

}
