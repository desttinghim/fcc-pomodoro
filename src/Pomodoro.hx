import mithril.M;
import haxe.Timer;
import js.Browser;

class Pomodoro implements Mithril {
  // time in seconds
  var currentTime : Int;
  // spinner elements, store session/break time in minutes
  var sessionTime : Spinner;
  var breakTime : Spinner;

  public function new(sessionTime, breakTime) {
    this.sessionTime = new Spinner(sessionTime);
    this.breakTime = new Spinner(breakTime);
    this.currentTime = 0;
    var secondsTimer = new Timer(1000);
    secondsTimer.run = function() {this.currentTime += 1; M.redraw();}
  }

  public function view() [
    m(sessionTime, {}),
    m(breakTime, {}),
    m('.currentTime', {}, Math.floor(currentTime / 60) + ':' + currentTime % 60)
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
