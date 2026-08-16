Class BeyondCode.OrderRecord Extends %Persistent
{

Property Amount As %Integer [ Required ];

Property Status As %String(VALUELIST = ",pending_payment,paid") [ InitialExpression = "pending_payment", Required ];

}
