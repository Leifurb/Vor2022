var result;

            function evaluateResult() {
                var userInput = document.getElementById("mathIn").value;
                if (userInput === String(result)) {
                    document.getElementById("resultMsg").style="display: block;";
                    document.getElementById("resultMsg").className="alert alert-success";
                    document.getElementById("resultMsg").textContent = "correct";
                } else {
                    document.getElementById("resultMsg").style="display: block;";
                    document.getElementById("resultMsg").className="alert alert-danger";
                    document.getElementById("resultMsg").textContent = "incorrect";
                }

                setTimeout(function(){
                    document.getElementById("resultMsg").textContent = "";
                    document.getElementById("resultMsg").style = "display:none;";
                    document.getElementById("mathIn").value = "";
                    newMathTask();
                }, 5000);
            }

            function printLoop() {
                document.getElementById("loopOutput").innerHTML = "";
                var number = document.getElementById("loopNumber").value;

                for (var i=1;i<=number;i++) {
                    if (i<number) {
                        printSingleLine(i, true);
                    } else {
                        printSingleLine(i, false);
                    }
                }
            }   

            function printSingleLine(i, newLine) {
                setTimeout( function() {
                        document.getElementById("loopOutput").innerHTML = document.getElementById("loopOutput").innerHTML + i;
                        if (newLine) {
                            document.getElementById("loopOutput").innerHTML = document.getElementById("loopOutput").innerHTML + "<br>";
                        }
                    }, 10);
            }

            function newMathTask () {
                var num1 = Math.floor(Math.random() * 10) + 1;
                var num2 = Math.floor(Math.random() * 10) + 1;
                var op = Math.floor(Math.random() * 3) + 1;
                var temp;
                var taskField = document.getElementById("taskMsg");

                //Swap if needed
                if (num1 < num2) {
                    temp = num1;
                    num1 = num2;
                    num2 = temp;
                }

                if (op === 1) {
                    taskField.textContent = "Calculate " + num1 + " + " + num2;
                    result = num1 + num2;
                } else if (op === 2) {
                    taskField.textContent = "Calculate " + num1 + " - " + num2;
                    result = num1 - num2;
                } else {
                    taskField.textContent = "Calculate " + num1 + " * " + num2;
                    result = num1 * num2;
                }
            }

            newMathTask();