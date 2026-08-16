Class BeyondCode.PaymentGatewaySimulator
{

ClassMethod RequestCharge(pOrderId As %Integer, pAmount As %Integer, pAttemptKey As %String) As %DynamicObject
{
    if pAttemptKey = "" {
        set charge = {}
        set charge.status = "error"
        set charge.error = "attempt key is required"
        quit charge
    }

    set providerPaymentId = $get(^BeyondCodePaymentGateway("attempts", pAttemptKey, "provider_payment_id"))
    if providerPaymentId '= "" {
        set existingOrderId = $get(^BeyondCodePaymentGateway("attempts", pAttemptKey, "order_id"))
        set existingAmount = $get(^BeyondCodePaymentGateway("charges", existingOrderId, providerPaymentId, "amount"))
        if (existingOrderId '= pOrderId) || (existingAmount '= pAmount) {
            set charge = {}
            set charge.status = "error"
            set charge.error = "attempt key belongs to a different charge"
            quit charge
        }
    } else {
        set providerPaymentId = "pay_"_$translate($system.Util.CreateGUID(), "-{}", "")
        set ^BeyondCodePaymentGateway("attempts", pAttemptKey, "provider_payment_id") = providerPaymentId
        set ^BeyondCodePaymentGateway("attempts", pAttemptKey, "order_id") = pOrderId
        set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "amount") = pAmount
        set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "attempt_key") = pAttemptKey
        set ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "status") = "accepted"
    }

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
        set charge.attempt_key = ^BeyondCodePaymentGateway("charges", pOrderId, providerPaymentId, "attempt_key")
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
