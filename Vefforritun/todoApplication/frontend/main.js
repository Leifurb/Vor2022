
function getAllTodos() {
    var noteList = document.getElementById("noteList");
    noteList.innerHTML='';

    var url = 'http://localhost:3000/api/vEx0/notes';

    axios.get(url)
        .then(function (response) {
            if (response.data !== null) {
                for (var i = 0; i < response.data.length; i++) {
                    var noteItem = document.createElement("p");
                    var noteText = document.createTextNode("Name: " + response.data[i].name + ", Content: " + response.data[i].content + " " + ", Prio: " + response.data[i].priority + "\n");
                    var noteButton = document.createElement('button');
                    var buttonText = document.createTextNode("Delete node");
                    noteButton.setAttribute('type', 'button')
                    noteButton.setAttribute("onclick", 'deleteNote(' + response.data[i].id + ')')
            
                   

                    noteItem.appendChild(noteText);
                    noteButton.appendChild(buttonText);
                    noteItem.appendChild(noteButton);
                    noteList.appendChild(noteItem);
                    

                }
            }
        })
        .catch(function (error) {
            //When unsuccessful, print the error.
            console.log(error);
        });

}

function deleteNote(id) {
    var url = 'http://localhost:3000/api/vEx0/notes';
    axios.delete(url+ '/'+ id)
        .then(function (response) {
            getAllTodos()
        })
}
getAllTodos();