import mithril.M;
import haxe.Timer;
import js.Browser;

@:enum abstract PomodoroState(String) from String {
  var Working = "Working";
  var Break = "Break!";
  var Paused = "Paused";
}

class Pomodoro implements Mithril {
  // time in seconds
  var currentTime : Float;

  var secondsTimer : Timer;
  // spinner elements, store session/break time in minutes
  var sessionTime : Spinner;
  var breakTime : Spinner;

  var previousState : PomodoroState;
  var state : PomodoroState;

  public function new(sessionTime, breakTime) {
    this.sessionTime = new Spinner(sessionTime);
    this.breakTime = new Spinner(breakTime);
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

  public function view() [
    m('.spinner
      display: inline-block;', {}, [m('p', {}, 'Session:'), m(sessionTime, {}),]),
    m('.spinner
      display: inline-block;', {}, [m('p', {}, 'Break:'), m(breakTime, {}),]),
    m('p', {}, state),
    m('.currentTime', {}, DateTools.format(Date.fromTime(currentTime ), "%M:%S")),
    secondsTimer == null ? m('button', {onclick: start}, 'start')
    : m('button', {onclick: stop}, 'stop'),
  ];

  static function main() {M.mount(Browser.document.body, new Pomodoro(25, 5));}
}

class Spinner implements Mithril {

  public var value(default, set) : Int;

  public function new(value=0) {
    this.value = value;
  }

  public function set_value(newValue):Int {
    return this.value = cast Math.max(1, newValue);
  }

  public function view() [
    m('.spinner', {}, [
      //TODO: propogate value changes back up to pomodoro
      m('button', {onclick: function(e) value += 1}, '+'),
      m('p', {}, value),
      m('button', {onclick: function(e) {value -= 1;}}, '-'),
    ]),
  ];

}
