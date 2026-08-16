Class BeyondCode.Tests.BaselinePaymentFlowTest Extends %UnitTest.TestCase
{

Method OnBeforeOneTest() As %Status
{
    quit ##class(BeyondCode.PaymentService).Reset()
}

Method TestOrderCanBeCreated()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do $$$AssertEquals(2599, order.amount)
    do $$$AssertEquals("pending_payment", order.status)
}

Method TestUnpaidOrderCanBePaid()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do $$$AssertTrue(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_baseline", .result, .error), error)
    do $$$AssertEquals("succeeded", result.payment.status)
    do $$$AssertEquals("paid", result.order.status)
}

Method TestSuccessfulConfirmationMakesOrderPaid()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(4800, .order, .error), error)
    set orderObject = ##class(BeyondCode.OrderRecord).%OpenId(order.id)
    set payment = ##class(BeyondCode.PaymentRecord).%New()
    set payment.Order = orderObject
    set payment.Amount = orderObject.Amount
    set payment.AttemptKey = "attempt_confirmation"
    set payment.Status = "accepted"
    set payment.ProviderPaymentId = "pay_test_confirmation"
    do $$$AssertStatusOK(payment.%Save())

    do $$$AssertTrue(##class(BeyondCode.PaymentService).ConfirmPayment("pay_test_confirmation", "succeeded", .confirmed, .error), error)
    do $$$AssertEquals("succeeded", confirmed.status)
    do $$$AssertTrue(##class(BeyondCode.PaymentService).GetOrder(order.id, .updatedOrder))
    do $$$AssertEquals("paid", updatedOrder.status)
}

Method TestAlreadyPaidOrderCannotBePaidAgain()
{
    do $$$AssertTrue(##class(BeyondCode.PaymentService).CreateOrder(2599, .order, .error), error)
    do $$$AssertTrue(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_paid", .firstResult, .error), error)
    do $$$AssertFalse(##class(BeyondCode.PaymentService).PayOrder(order.id, "attempt_after_paid", .secondResult, .secondError))
    do $$$AssertEquals("order is already paid", secondError)

    set rows = ##class(%SQL.Statement).%ExecDirect(, "SELECT COUNT(*) AS PaymentCount FROM BeyondCode.PaymentRecord WHERE Order = ?", order.id)
    do rows.%Next()
    do $$$AssertEquals(1, rows.%Get("PaymentCount"))
}

}
