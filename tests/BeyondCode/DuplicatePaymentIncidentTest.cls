Class BeyondCode.Tests.DuplicatePaymentIncidentTest Extends %UnitTest.TestCase
{

Method OnBeforeOneTest() As %Status
{
    quit ##class(BeyondCode.PaymentService).Reset()
}

Method TestRetryAfterAmbiguousTimeoutReusesProviderCharge()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("timeout_after_acceptance")

    do $$$AssertFalse(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_A", .firstResult, .firstError))
    do $$$AssertTrue(firstError [ "outcome is unknown")
    do $$$AssertEquals(1, ##class(BeyondCode.PaymentGatewaySimulator).CountChargesForOrder(order.id))

    set firstCharges = ##class(BeyondCode.PaymentGatewaySimulator).GetChargesForOrder(order.id)
    set firstCharge = firstCharges.%Get(0)
    do $$$AssertEquals(order.id, firstCharge.order_id)
    do $$$AssertEquals(2599, firstCharge.amount)
    do $$$AssertEquals("attempt_A", firstCharge.attempt_key)
    do $$$AssertEquals("accepted", firstCharge.status)
    do ..AssertLocalPaymentCount(order.id, 1)

    do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("normal")
    do $$$AssertTrue(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_A", .secondResult, .secondError), secondError)

    set providerCharges = ##class(BeyondCode.PaymentGatewaySimulator).GetChargesForOrder(order.id)
    do $$$AssertEquals(1, providerCharges.%Size())
    set retryCharge = providerCharges.%Get(0)
    do $$$AssertEquals(firstCharge.provider_payment_id, retryCharge.provider_payment_id)
    do ..AssertLocalPaymentCount(order.id, 1)
    do $$$AssertEquals("attempt_A", secondResult.payment.attempt_key)
    do $$$AssertEquals("succeeded", secondResult.payment.status)
    do $$$AssertEquals("paid", secondResult.order.status)
}

Method TestDifferentAttemptKeysCreateDifferentAttempts()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("timeout_after_acceptance")

    do $$$AssertFalse(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_A", .firstResult, .firstError))
    do $$$AssertFalse(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_B", .secondResult, .secondError))
    do $$$AssertTrue(firstError [ "outcome is unknown")
    do $$$AssertTrue(secondError [ "outcome is unknown")

    do $$$AssertEquals(2, ##class(BeyondCode.PaymentGatewaySimulator).CountChargesForOrder(order.id))
    do ..AssertLocalPaymentCount(order.id, 2)
    do $$$AssertTrue(##class(BeyondCode.PaymentService).GetOrder(order.id, .pendingOrder))
    do $$$AssertEquals("pending_payment", pendingOrder.status)

    set rows = ##class(%SQL.Statement).%ExecDirect(, "SELECT AttemptKey FROM BeyondCode.PaymentRecord WHERE Order = ? ORDER BY AttemptKey", order.id)
    do $$$AssertTrue(rows.%Next())
    do $$$AssertEquals("attempt_A", rows.%Get("AttemptKey"))
    do $$$AssertTrue(rows.%Next())
    do $$$AssertEquals("attempt_B", rows.%Get("AttemptKey"))
}

Method AssertLocalPaymentCount(pOrderId As %Integer, pExpected As %Integer)
{
    set rows = ##class(%SQL.Statement).%ExecDirect(, "SELECT COUNT(*) AS PaymentCount FROM BeyondCode.PaymentRecord WHERE Order = ?", pOrderId)
    do rows.%Next()
    do $$$AssertEquals(pExpected, rows.%Get("PaymentCount"))
}

}
