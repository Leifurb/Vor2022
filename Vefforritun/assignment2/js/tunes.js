var dropdowndata = {};
var recording = {};
var recordon = false;
var recordstart;
//We initialise the synthesiser
var synth = new Tone.Synth().toDestination();

function playTune (note) {
    //initialise a timer to decide when to play individual notes
    var now = Tone.now();

    synth.triggerAttackRelease(note, "8n");
    if (recordon == true){
        recording["tune"].push({"duration": "8n", "note": note, "timing": parseFloat(now - recordstart)}); 

    }
}
function startRecording (note, duration, time) {
    document.getElementById("stopbtn").disabled = false; 
    recordon = true;
    recordstart = Tone.now();
    var name = document.getElementById("recordName").value;
    if (name == '') {
        name = "Unnamed Tune"
    }
    recording = {
        "name": name,
        "tune": []
    }
}
function stopRecording(){
    document.getElementById("stopbtn").disabled = true;

    let url = 'https://veff2022-hmv-aku.herokuapp.com/api/v1/tunes';
    //Perform a GET request to the url
    if (recording["tune"].length > 0){
        axios.post(url, recording)
            .then(function (response) {
            //When successful, print the received data
                dropdowndata = {};
                document.getElementById("tunesDrop").innerHTML = null;
                getAllTunes();
            })
            .catch(function (error) {
                //When unsuccessful, print the error
                console.log(error);
            })
        }
    }
function playSong () {
    var select = document.getElementById("tunesDrop");
    var selectedValue = select.options[select.selectedIndex].value;
    var d = dropdowndata;
    
    var now = Tone.now();
    for (var i=0;i<dropdowndata[selectedValue].length;i++) {
        synth.triggerAttackRelease(d[selectedValue][i].note,d[selectedValue][i].duration, now + d[selectedValue][i].timing);
    }

}
// Execute a function when the user releases a key on the keyboard
document.addEventListener("keyup", function(event) {
// Number 13 is the "Enter" key on the keyboard
    if (event.key == 'a') 
        {
        playTune("C4");
        }
    if (event.key == 'w') 
        {
        playTune("C#4");
        }
    if (event.key == 's') 
        {
        playTune("D4");
        }
    if (event.key == 'e') 
        {
        playTune("D#4");
        }
    if (event.key == 'd') 
        {
        playTune("E4");
        }
    if (event.key == 'f') 
        {
        playTune("F4");
        }
    if (event.key == 't') 
        {
        playTune("F#4");
        }
    if (event.key == 'g') 
        {
        playTune("G4");
        }
    if (event.key == 'y') 
        {
        playTune("G#4");
        }
    if (event.key == 'h') 
        {
        playTune("A4");
        }
    if (event.key == 'u') 
        {
        playTune("Bb4");
        }
    if (event.key == 'j') 
        {
        playTune("B4");
        }
    if (event.key == 'k') 
        {
        playTune("C5");
        }
    if (event.key == 'o') 
        {
        playTune("C#5");
        }
    if (event.key == 'l') 
        {
        playTune("D5");
        }
    if (event.key == 'p') 
        {
        playTune("D#5");
        }
    if (event.key == ';') 
        {
        playTune("E5");
        }
})
function dropdown(response){
    var select = document.getElementById("tunesDrop");
    for (var i=0;i<response.data.length;i++) {
        select.options[select.options.length] = new Option(response.data[i].name, response.data[i].id);
        dropdowndata[response.data[i].id] = response.data[i].tune
    
        console.log("Tune name: " + response.data[i].name);
    }
}
function getAllTunes() {
    //The URL to which we will send the request
    let url = 'https://veff2022-hmv-aku.herokuapp.com/api/v1/tunes';

    //Perform a GET request to the url
    axios.get(url)
        .then(function (response) {
            //When successful, print the received data
    
            dropdown(response);
            
        })
        .catch(function (error) {
            //When unsuccessful, print the error
            console.log(error);
        })
        .then(function () {
            // This code is always executed, independent of whether the request succeeds or fails.
        });
    }
window.onload = function() {
    getAllTunes();
}
