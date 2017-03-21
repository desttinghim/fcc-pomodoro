import mithril.M;

class Pomodoro implements Mithril {
  // times in seconds
  var currentTime : Int;
  var sessionTime : Int;
  var breakTime : Int;

  public function new(sessionTime, breakTime) {
    this.sessionTime = sessionTime;
    this.breakTime = breakTime;
    this.currentTime = 0;
    var secondsTimer = new haxe.Timer(1000);
    secondsTimer.run = function() {this.currentTime += 1; M.redraw();}
  }

  public function view() [
    m(new Spinner(sessionTime), {}),
    m(new Spinner(breakTime), {}),
    m('.currentTime', {}, Math.floor(currentTime / 60) + ':' + currentTime % 60)
  ];

  static function main() {M.mount(js.Browser.document.body, new Pomodoro(25*60, 5*60));}
}

class Spinner implements Mithril {
  var value : Int;
  public function new(value=0) {
    this.value = value;
  }

  public function view() [
    m('.spinner', {}, [
      //TODO: propogate value changes back up to pomodoro
      m('button', {onclick: function(e) {value -= 1; trace(value);}}, '-'),
      m('p', {}, value),
      m('button', {onclick: function(e) value += 1}, '+'),
    ]),
  ];

}
