const data = document.currentScript.dataset;
const qanda = data.qanda;
const timelimit = data.timelimit;
const tmp =  qanda.replace(/\n/g, " ")
                  .replace(/\'/g, "\"")
                  .replace(/False/g, "false")
                  .replace(/True/g, "true");
const questions = JSON.parse(tmp)

const questionView = document.querySelector(".question");
const resultsView = document.querySelector(".results");
const totalQuestions = document.querySelector(".play-footer .total-questions");
const timeLine = document.querySelector(".play-header .time-line");
const timeText = document.querySelector(".timer .time-left-txt");
const timeCount = document.querySelector(".timer .timer-sec");
const tickIconTag = '<div class="icon tick"><i class="fas fa-check"></i></div>';
const crossIconTag = '<div class="icon cross"><i class="fas fa-times"></i></div>';
const question_text = document.querySelector(".question-text");
const option_list = document.querySelector(".option-list");
const next_btn = document.querySelector(".next-btn");
const scoreText = document.querySelector(".results .score-text");

let numCorrect = 0;
let questionNum = -1;
let counter = 0;
let counterLine = 0;
let widthValue = 0;

function showNextQuestion() {
  questionNum++;
  clearInterval(counter); //clear counter
  clearInterval(counterLine); //clear counterLine

  if (questionNum >= questions.length) {
    showResults();
    return;
  }
  
  displayQuestionCount();
  startTimer(timelimit); //calling startTimer function
  startTimerLine(widthValue); //calling startTimerLine function
  timeText.textContent = "Time Left"; //change the timeText to Time Left
  next_btn.classList.remove("show"); //hide the next button
  let question = "<span>" + (questionNum+1) + ". " + questions[questionNum].question + "</span>";
  question_text.innerHTML = question;

  let responses = '';
  for (let i=0; i < questions[questionNum].responses.length; i++) {
    let response = questions[questionNum].responses[i];
    responses += '<div class="option"><span>' + response + "</span></div>";
  };

  option_list.innerHTML = responses;
  const options = option_list.querySelectorAll(".option");
  console.log(options.length)
  for (i = 0; i < options.length; i++) {
    options[i].questionNum = questionNum;
    console.log('marc', i, options[i].questionNum)
    options[i].addEventListener("click", optionSelected, this);
  }

  elem = document.querySelector(".question");
  elem.classList.add("show");
}

function optionSelected(event) {
  let answer = event.currentTarget;
  let questionNum = answer.questionNum;
  clearInterval(counter);
  clearInterval(counterLine);
  let userAns = answer.textContent;
  let correctAns = questions[questionNum].correct;
  const allOptions = option_list.children.length;

  if (userAns == correctAns) {
    numCorrect += 1;
    answer.classList.add("correct");
    answer.insertAdjacentHTML("beforeend", tickIconTag);
    console.log("Correct! numCorrect: ", numCorrect);
  } else {
    answer.classList.add("incorrect");
    answer.insertAdjacentHTML("beforeend", crossIconTag);
    console.log("Wrong Answer");

    for (i = 0; i < allOptions; i++) {
      if (option_list.children[i].textContent == correctAns) {
        option_list.children[i].setAttribute("class", "option correct");
        option_list.children[i].insertAdjacentHTML("beforeend", tickIconTag);
        console.log("Auto selected correct answer.");
      }
    }
  }
  for (i = 0; i < allOptions; i++) {
    option_list.children[i].classList.add("disabled");
  }
  next_btn.classList.add("show");
}

function startTimer(time) {
  counter = setInterval(timer, 1000);
  function timer() {
    timeCount.textContent = time; //changing the value of timeCount with time value
    time--; //decrement the time value
    if (time < 9) {
      //if timer is less than 9
      let addZero = timeCount.textContent;
      timeCount.textContent = "0" + addZero; //add a 0 before time value
    }
    if (time < 0) {
      //if timer is less than 0
      clearInterval(counter); //clear counter
      timeText.textContent = "Time Out"; //change the time text to time off
      const allOptions = option_list.children.length; //getting all option items
      let correctAns = questions[question_num].answer; //getting correct answer from array
      for (i = 0; i < allOptions; i++) {
        if (option_list.children[i].textContent == correctAns) {
          //if there is an option which is matched to an array answer
          option_list.children[i].setAttribute("class", "option correct"); //adding green color to matched option
          option_list.children[i].insertAdjacentHTML("beforeend", tickIconTag); //adding tick icon to matched option
          console.log("Time out: auto selected correct answer.");
        }
      }
      for (i = 0; i < allOptions; i++) {
        option_list.children[i].classList.add("disabled"); //once user select an option then disabled all options
      }
      next_btn.classList.add("show"); //show the next button if user selected any option
    }
  }
}

function startTimerLine(time) {
  counterLine = setInterval(timer, 29);
  function timer() {
    time += 1;
    timeLine.style.width = time + "px";
    if (time > 549) {
      clearInterval(counterLine);
    }
  }
}

function displayQuestionCount() {
  let tmp = "<span>" + (questionNum + 1) + " of " + questions.length + " questions</span>";
  totalQuestions.innerHTML = tmp;
}

next_btn.onclick = (ev) => {
  showNextQuestion();
}

function enable(elem) {
  elem.classList.remove("hide");
  elem.classList.add("show");
}

function disable(elem) {
  elem.classList.remove("show");
  elem.classList.add("hide");
}

function showResults() {
  disable(questionView);
  enable(resultsView);
  let tmp = "<span>You correctly answered " + numCorrect + " out of " + questions.length + " questions</span>";
  scoreText.innerHTML = tmp;
}
