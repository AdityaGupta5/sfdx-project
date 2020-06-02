({
    createExpense: function(component, expense) {
        var theExpenses = component.get("v.expenses");
        var newExpense = JSON.parse(JSON.stringify(expense));
 
        theExpenses.push(newExpense);
        component.set("v.expenses", theExpenses);
    }
})