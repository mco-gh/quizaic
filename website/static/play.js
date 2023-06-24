const data = document.currentScript.dataset;
let quizid = data.quizid;
let player = data.name;
let sync = data.sync;
let survey = data.survey;
const questions = JSON.parse(data.qanda);
const timelimit = data.timelimit;

const standby = document.querySelector(".standby");
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
let counter = 0;
let counterLine = 0;
let widthValue = 0;
let correctAnswer = null;
let answers = [];

function showNextQuestion(questionNum) {
  console.log("showNextQuestion() for questionNum ", questionNum);
  clearInterval(counter); //clear counter
  clearInterval(counterLine); //clear counterLine

  if (questionNum == -1) {
    console.log("Quiz not started");
    enable(standby);
    disable(questionView);
  } else if (questionNum == 0) {
    disable(standby);
    enable(questionView);
    console.log("first question of a quiz so creating or resetting results for player " + player + " and quiz " + quizid + ".")
    answers = [];
    document.resetResults(player, quizid);
  } else if (questionNum >= questions.length) {
    enable(standby);
    disable(questionView);
    showResults();
    return;
  } else {
    disable(standby);
    enable(questionView);
  };
  
  console.log("questionNum", questionNum, "questions", questions);
  document.qnum = questionNum;
  displayQuestionCount(questionNum);
  startTimer(timelimit); //calling startTimer function
  startTimerLine(widthValue); //calling startTimerLine function
  timeText.textContent = "Time Left"; //change the timeText to Time Left
  disable(next_btn);
  let question = "<span>" + (questionNum+1) + ". " + questions[questionNum].question + "</span>";
  question_text.innerHTML = question;

  let responses = '';
  if ("responses" in questions[questionNum]) {
    for (let i=0; i < questions[questionNum].responses.length; i++) {
      let response = questions[questionNum].responses[i];
      responses += '<div class="option"><span>' + response + "</span></div>";
    };

    option_list.innerHTML = responses;
    const options = option_list.querySelectorAll(".option");
    for (i = 0; i < options.length; i++) {
      options[i].qnum = questionNum;
      options[i].addEventListener("click", optionSelected, this);
    }
  } else {
    response = `
      <form id="answer-input-form" onsubmit="return onSubmit(this)">
        <label for="name">Your answer:</label>&nbsp;
        <input id="answer-input" type="text" id="name" name="name"><br><br>
        <input id="answer-input-button" class="mdc-button mdc-button--raised" type="submit" value="Submit">
      </form>
      <div id="answer-input-feedback" style="display: none" class="option disabled"></div>
    `;
    option_list.innerHTML = response;
  }
  elem = document.querySelector(".question");
  elem.classList.add("show");
}

function onSubmit() {
  let answer_input = document.getElementById("answer-input");
  let answer_input_feedback = document.getElementById("answer-input-feedback");
  let userAns = answer_input.value;
  let qnum = document.qnum;
  let correctAns = questions[qnum].correct;
  let feedback = "";
  let indicator = "";
  console.log("answer: ", userAns, "correct:", correctAns);
  clearInterval(counter);
  clearInterval(counterLine);
  let pad = "&nbsp;&nbsp;&nbsp;"
  if (userAns == correctAns) {
    numCorrect += 1;
    console.log("Correct! numCorrect: ", numCorrect);
    feedback = `<span>Well done - You guessed the correct answer!${pad}</span>` + tickIconTag;
    answer_input_feedback.classList.add("correct");
  } else {
    console.log("Wrong Answer");
    feedback = `<span>Sorry, the correct answer was ${correctAns}.${pad}</span>` + crossIconTag;
    answer_input_feedback.classList.add("incorrect");
  }
  let button = document.getElementById("answer-input-button");
  disable(button);
  answer_input.disabled = true;
  answer_input_feedback.innerHTML = feedback;
  answer_input_feedback.style.display = "inline-flex";
  if (sync == "False") {
    console.log('show next button');
    enable(next_btn);
  };
  return false;
}

function optionSelected(event) {
  let answer = event.currentTarget;
  let qnum = answer.qnum;
  clearInterval(counter);
  clearInterval(counterLine);
  let userAns = answer.textContent;
  let correctAns = questions[qnum].correct;
  const allOptions = option_list.children.length;

  while (answers.length < qnum) {
    answers.push("N/A");
  }
  answers.push(userAns);
  console.log("posting results for player " + player + " and quiz " + quizid + ": " + answers + ".")
  document.postResults(player, quizid, answers, qnum + 1);

  if (userAns == correctAns || survey) {
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
  if (sync == "False") {
    console.log('show next button');
    enable(next_btn);
  };
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
      let correctAns = questions[document.qnum].answer; //getting correct answer from array
      for (i = 0; i < allOptions; i++) {
        if (option_list.children[i].textContent == correctAnswer) {
          //if there is an option which is matched to an array answer
          option_list.children[i].setAttribute("class", "option correct"); //adding green color to matched option
          option_list.children[i].insertAdjacentHTML("beforeend", tickIconTag); //adding tick icon to matched option
          console.log("Time out: auto selected correct answer.");
        }
        while (answers.length <= document.qnum) {
          answers.push("N/A");
        }
        console.log("posting results for player " + player + " and quiz " + quizid + ": " + answers + ".")
        document.postResults(player, quizid, answers, document.qnum + 1);
      }
      for (i = 0; i < allOptions; i++) {
        option_list.children[i].classList.add("disabled"); //once user select an option then disabled all options
      }
      //next_btn.classList.add("show"); //show the next button if user selected any option
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

function displayQuestionCount(qnum) {
  let tmp = "<span>" + (qnum + 1) + " of " + questions.length + " questions</span>";
  totalQuestions.innerHTML = tmp;
}

next_btn.onclick = (ev) => {
  let qnum = document.qnum + 1;
  showNextQuestion(qnum);
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
