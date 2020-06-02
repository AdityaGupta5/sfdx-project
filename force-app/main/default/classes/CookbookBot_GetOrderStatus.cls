public class CookbookBot_GetOrderStatus {

    public class OrderInput {
        @InvocableVariable(required=true)
        public String orderNumber;
    }
    public class OrderOutput {
        @InvocableVariable(required=true)
        public String orderStatus;
    }
    
    @InvocableMethod(label='Get Order Status')
    public static List<OrderOutput> getOrderStatus(List<OrderInput> orderInputs) {
    	set<String> orderNumbers = new set<String>();
        // Get the order numbers from the input
        For(OrderInput orderInput : orderInputs) {
            orderNumbers.add(orderInput.orderNumber);
        }
        // Get the order object records from the set of order numbers
        List<Order> orders = [Select Name, OrderNumber, Order_Number__c, Description, TotalAmount, Type, Status From Order 
                              Where /*OrderNumber*/ Order_Number__c IN: orderNumbers];
        
        // Create a map of order numbers and order status values
        Map<String, String> mapOrderStatus = new Map<String, String>();
        If(orders != Null && orders.size() > 0){
            For(Order orderObj : orders) {
                mapOrderStatus.put(orderObj.Order_Number__c/*OrderNumber*/, orderObj.Status); 
            }    
        }
        
        // Build a list of order status values for the output
		List<OrderOutput> orderOutputs = new List<OrderOutput>();
        For(OrderInput orderInput : orderInputs) {
        	OrderOutput orderOutput = new OrderOutput();
            // Do we have a status for this order number?
            if(mapOrderStatus.containsKey(orderInput.orderNumber)) {
                // If so, then add the status
            	orderOutput.orderStatus = mapOrderStatus.get(orderInput.orderNumber);    
            } else {
                // If not, then add an unknown status value
                orderOutput.orderStatus = 'Order Not found';
            }
            orderOutputs.add(orderOutput);
        }
        return orderOutputs;
    }
}