import mithril.M;
import haxe.Timer;
import js.Browser;

@:enum abstract PomodoroState(String) from String {
  var Working = "Working";
  var Break = "Break!";
  var Paused = "Paused";
}

class Pomodoro implements Mithril {

  static function main() {M.mount(Browser.document.body, new Pomodoro(25, 5));}

  // time in ms
  var currentTime : Float;

  var secondsTimer : Timer;
  // spinner elements, store session/break time in minutes
  var sessionTime : Spinner;
  var breakTime : Spinner;

  var previousState : PomodoroState;
  var state : PomodoroState;

  public function new(sessionTime, breakTime) {
    this.sessionTime = new Spinner(sessionTime, "Session");
    this.breakTime = new Spinner(breakTime, "Break");
    this.currentTime = 0;
    this.state = Paused;
    this.previousState = Paused;
    this.secondsTimer = null;
  }

  function start() {
    if (previousState == Paused) {state = Working;}
    else {state = previousState;}
    setTitle(state);
    if (secondsTimer != null) return;
    secondsTimer = new Timer(1000);
    secondsTimer.run = update;
  }

  function stop() {
    previousState = state;
    state = Paused;
    setTitle(state);
    if (secondsTimer == null) return;
    secondsTimer.stop();
    secondsTimer = null;
  }

  function reset() {
    previousState = Paused;
    state = Working;
    setTitle(state);

    currentTime = 0;
    if (secondsTimer == null) return;
    secondsTimer.stop();
    secondsTimer = null;
  }

  function update() {
    state = switch (state) {
      case Working if (currentTime > sessionTime.value * 60000): {
        previousState = state;
        currentTime = 0;
        Break;
      }
      case Break if (currentTime > breakTime.value * 60000): {
        previousState = state;
        currentTime = 0;
        Working;
      }
      default: state;
    }
    setTitle(state);
    this.currentTime += 1000;
    M.redraw();
  }

  function setTitle(str:Dynamic) {
    Browser.document.title = '$str - Pomodoro';
  }

  static inline var btnStr = 'button.btn.col-xs-12';
  function pauseOrPlay(){
    return secondsTimer == null
      ? m('${btnStr}.btn-success', {onclick: start}, 'start')
      : m('${btnStr}.btn-warning', {onclick: stop}, 'stop');}

  public function view()
    m('.pomodoro.container.col-xs-12', [
      m('h1.center', 'Pomodoro'),
      m(sessionTime),
      m(breakTime),
      m('p.state.center.col-xs-12', {}, state),
      m('.currentTime.center.col-xs-12', {}, DateTools.format(Date.fromTime(currentTime ), "%M:%S")),
      pauseOrPlay(),
      m('${btnStr}', {onclick: reset}, 'reset'),
  ]); //view

}

class Spinner implements Mithril {

  public var label : String;
  public var value(default, set) : Int;

  public function new(value=0, label="") {
    this.value = value;
    this.label = label;
  }

  public function set_value(newValue):Int {
    return this.value = cast Math.max(1, newValue);
  }

  public function view() [
    m('.spinner.col-xs-6', {}, [
      m('p.center', label),
      m('button.btn.col-xs-4', {onclick: function(e) {value -= 1;}}, '-'),
      m('p.inline.col-xs-4', value),
      m('button.btn.col-xs-4', {onclick: function(e) value += 1}, '+'),
    ]),
  ];

}
