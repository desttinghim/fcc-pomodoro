import mithril.M;
import haxe.Timer;
import js.Browser;

class Pomodoro implements Mithril {
  // time in seconds
  var startTime : Float;
  var currentTime : Float;
  // spinner elements, store session/break time in minutes
  var sessionTime : Spinner;
  var breakTime : Spinner;

  public function new(sessionTime, breakTime) {
    this.sessionTime = new Spinner(sessionTime);
    this.breakTime = new Spinner(breakTime);
    this.startTime = Date.now().getTime();
    this.currentTime = startTime;
    var secondsTimer = new Timer(1000);
    secondsTimer.run = function() {this.currentTime = Date.now().getTime(); M.redraw();}
  }

  public function view() [
    m(sessionTime, {}),
    m(breakTime, {}),
    m('.currentTime', {}, DateTools.format(Date.fromTime(currentTime - startTime), "%M:%S"))
  ];

  static function main() {M.mount(Browser.document.body, new Pomodoro(25, 5));}
}

class Spinner implements Mithril {
  public var value : Int;
  public function new(value=0) {
    this.value = value;
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
