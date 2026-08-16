Class BeyondCode.REST Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/orders" Method="POST" Call="CreateOrder"/>
    <Route Url="/orders/:orderId" Method="GET" Call="GetOrder"/>
    <Route Url="/orders/:orderId/pay" Method="POST" Call="PayOrder"/>
    <Route Url="/webhooks/payment" Method="POST" Call="PaymentWebhook"/>
</Routes>
}

ClassMethod CreateOrder() As %Status
{
    set payload = ..ReadJSON()
    if '$isobject(payload) quit ..WriteError(400, "valid JSON is required")
    if '##class(BeyondCode.PaymentService).CreateOrder(payload.amount, .order, .error) quit ..WriteError(400, error)
    quit ..WriteJSON(201, order)
}

ClassMethod GetOrder(orderId As %String) As %Status
{
    if '##class(BeyondCode.PaymentService).GetOrder(orderId, .order) quit ..WriteError(404, "order not found")
    quit ..WriteJSON(200, order)
}

ClassMethod PayOrder(orderId As %String) As %Status
{
    if '##class(BeyondCode.PaymentService).PayOrder(orderId, .result, .error) {
        set status = $select(error="order not found":404, error="order is already paid":409, 1:500)
        quit ..WriteError(status, error)
    }
    quit ..WriteJSON(201, result)
}

ClassMethod PaymentWebhook() As %Status
{
    set payload = ..ReadJSON()
    if '$isobject(payload) quit ..WriteError(400, "valid JSON is required")
    if '##class(BeyondCode.PaymentService).ConfirmPayment(payload.provider_payment_id, payload.status, .payment, .error) {
        set status = $select(error="payment not found":404, 1:400)
        quit ..WriteError(status, error)
    }
    set result = {}
    set result.payment = payment
    quit ..WriteJSON(200, result)
}

ClassMethod ReadJSON() As %DynamicObject [ Private ]
{
    try {
        set body = %request.Content.Read()
        quit:body="" {}
        quit {}.%FromJSON(body)
    } catch {
        quit ""
    }
}

ClassMethod WriteError(pStatus As %Integer, pMessage As %String) As %Status [ Private ]
{
    set body = {}
    set body.error = pMessage
    quit ..WriteJSON(pStatus, body)
}

ClassMethod WriteJSON(pStatus As %Integer, pBody As %DynamicObject) As %Status [ Private ]
{
    set %response.Status = pStatus
    set %response.ContentType = "application/json"
    do pBody.%ToJSON()
    quit $$$OK
}

}
