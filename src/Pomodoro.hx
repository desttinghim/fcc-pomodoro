import mithril.M;
import haxe.Timer;
import js.Browser;

@:enum abstract PomodoroState(String) from String {
  var Working = "Working...";
  var Break = "Break!";
}

class Pomodoro implements Mithril {
  // time in seconds
  var startTime : Float;
  var currentTime : Float;
  // spinner elements, store session/break time in minutes
  var sessionTime : Spinner;
  var breakTime : Spinner;

  var state : PomodoroState;

  public function new(sessionTime, breakTime) {
    this.sessionTime = new Spinner(sessionTime);
    this.breakTime = new Spinner(breakTime);
    this.startTime = Date.now().getTime();
    this.currentTime = startTime;
    this.state = Working;
    var secondsTimer = new Timer(1000);
    secondsTimer.run = update;
  }

  function update() {
    var timeDelta = currentTime - startTime;
    state = switch (state) {
      case Working if (timeDelta > sessionTime.value * 60000): {startTime = currentTime; Break;}
      case Break if (timeDelta > breakTime.value * 60000): {startTime = currentTime; Working;}
      default: state;
    }
    this.currentTime = Date.now().getTime();
    M.redraw();
  }

  public function view() [
    m(sessionTime, {}),
    m(breakTime, {}),
    m('p', {}, state),
    m('.currentTime', {}, DateTools.format(Date.fromTime(currentTime - startTime), "%M:%S"))
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
      m('button', {onclick: function(e) {value -= 1;}}, '-'),
      m('p', {}, value),
      m('button', {onclick: function(e) value += 1}, '+'),
    ]),
  ];

}
