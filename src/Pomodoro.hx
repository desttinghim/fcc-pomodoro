import mithril.M;

class Pomodoro implements Mithril
{
  // times in seconds
  var currentTime : Int;
  var sessionTime : Int;
  var breakTime : Int;

  public function new(sessionTime, breakTime) {
    this.sessionTime = sessionTime;
    this.breakTime = breakTime;
    this.currentTime = 0;
    var secondsTimer = new haxe.Timer(1000);
    secondsTimer.run = function() {this.currentTime += 1;}
  }

  public function view() [
    m('input', {
      oninput: function(e) sessionTime = e.target.value * 60,
      value: Math.floor(sessionTime / 60)
    }),
    m('input', {
      oninput: function(e) breakTime = e.target.value * 60,
      value: Math.floor(breakTime / 60)
    }),
    m('.session', {}, sessionTime),
    m('.break', {}, breakTime),
    m('.currentTime', {
      scir
    }, Math.floor(currentTime / 60) + ':' + currentTime % 60)
  ];

  static function main() {M.mount(js.Browser.document.body, new Pomodoro(25*60, 5*60));}
}
