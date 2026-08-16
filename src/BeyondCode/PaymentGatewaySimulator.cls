Class BeyondCode.PaymentGatewaySimulator
{

ClassMethod RequestCharge(pOrderId As %Integer, pAmount As %Integer) As %DynamicObject
{
    set providerPaymentId = "pay_"_$translate($system.Util.CreateGUID(), "-{}", "")
    set confirmation = {}
    set confirmation.provider_payment_id = providerPaymentId
    set confirmation.status = "succeeded"

    set charge = {}
    set charge.provider_payment_id = providerPaymentId
    set charge.status = "accepted"
    set charge.confirmation = confirmation
    quit charge
}

}
