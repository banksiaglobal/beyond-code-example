Class BeyondCode.PaymentRecord Extends %Persistent
{

Property Order As BeyondCode.OrderRecord [ Required ];

Property Amount As %Integer [ Required ];

Property AttemptKey As %String(128) [ Required ];

Property Status As %String(VALUELIST = ",pending,accepted,succeeded") [ Required ];

Property ProviderPaymentId As %String;

Index AttemptKeyIndex On AttemptKey [ Unique ];

Index ProviderPaymentIdIndex On ProviderPaymentId;

}
