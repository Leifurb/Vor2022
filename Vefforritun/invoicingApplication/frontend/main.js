

function getAllInvoices() {
    var invoiceList = document.getElementById("invoiceList");
    invoiceList.innerHTML='';

    var url = 'http://localhost:3000/api/vEx1/invoices';

    axios.get(url)
        .then(function (response) {
            if (response.data !== null) {
                for (var i = 0; i < response.data.length; i++) {
                    var invoiceItem = document.createElement("span");
                    invoiceItem.textContent = "Invoice nr: " + response.data[i].invoice_number + ", invoiced by: " + response.data[i].invoiced_by + ", to: " + response.data[i].invoiced_to + ", amount: " + response.data[i].amount + "\n";
                    invoiceList.appendChild(invoiceItem);
                }
            }
        })
        .catch(function (error) {
            //When unsuccessful, print the error.
            console.log(error);
        });

}


function newInvoice(){
    var inum = document.getElementById("iNumber").value;
    var itname = document.getElementById("iToName").value;
    var ibname = document.getElementById("iByName").value;
    var iam = document.getElementById("iAmount").value;


    var url = 'http://localhost:3000/api/vEx1/invoices';

    if (inum.length > 0 && iam > 0){
        axios.post(url, {invoice_number: inum, invoiced_by: ibname, invoiced_to: itname, amount: iam, paid_status: 'unpaid'})
            .then(function (response) {
                console.log('success', response.data);
                getAllInvoices();
            })
            .catch(function (error) {
                //When unsuccessful, print the error.
                console.log(error);
            });
    }
}

getAllInvoices();