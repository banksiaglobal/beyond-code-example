Class BeyondCode.Tests.DuplicatePaymentIncidentTest Extends %UnitTest.TestCase
{

Method OnBeforeOneTest() As %Status
{
    do ##class(BeyondCode.PaymentGatewaySimulator).Reset()
    quit ##class(BeyondCode.PaymentService).Reset()
}

Method TestRetryAfterAmbiguousTimeoutCreatesTwoProviderCharges()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("timeout_after_acceptance")

    do $$$AssertFalse(##class(BeyondCode.PaymentService).PayOrder(order.id, .firstResult, .firstError))
    do $$$AssertTrue(firstError [ "outcome is unknown")
    do $$$AssertEquals(1, ##class(BeyondCode.PaymentGatewaySimulator).CountChargesForOrder(order.id))

    set firstCharges = ##class(BeyondCode.PaymentGatewaySimulator).GetChargesForOrder(order.id)
    set firstCharge = firstCharges.%Get(0)
    do $$$AssertEquals(order.id, firstCharge.order_id)
    do $$$AssertEquals(2599, firstCharge.amount)
    do $$$AssertEquals("accepted", firstCharge.status)
    do ..AssertLocalPaymentCount(order.id, 0)

    do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("normal")
    do $$$AssertTrue(##class(BeyondCode.PaymentService).PayOrder(order.id, .secondResult, .secondError), secondError)

    set providerCharges = ##class(BeyondCode.PaymentGatewaySimulator).GetChargesForOrder(order.id)
    do $$$AssertEquals(2, providerCharges.%Size())
    set firstProviderCharge = providerCharges.%Get(0)
    set secondProviderCharge = providerCharges.%Get(1)
    do $$$AssertNotEquals(firstProviderCharge.provider_payment_id, secondProviderCharge.provider_payment_id)
    do ..AssertLocalPaymentCount(order.id, 1)
    do $$$AssertEquals("paid", secondResult.order.status)
}

Method AssertLocalPaymentCount(pOrderId As %Integer, pExpected As %Integer)
{
    set rows = ##class(%SQL.Statement).%ExecDirect(, "SELECT COUNT(*) AS PaymentCount FROM BeyondCode.PaymentRecord WHERE Order = ?", pOrderId)
    do rows.%Next()
    do $$$AssertEquals(pExpected, rows.%Get("PaymentCount"))
}

}
