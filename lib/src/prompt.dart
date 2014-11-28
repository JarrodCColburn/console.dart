part of console;

const List<String> _YES_RESPONSES = const [
  "yes",
  "y",
  "sure",
  "ok",
  "yep",
  "yeah",
  "true",
  "yerp"
];

/// Prompts a user with the specified [prompt].
/// If [secret] is true, then the typed input wont be shown to the user.
String prompt(String prompt, {bool secret: false}) {
  _STDOUT.write(prompt);
  
  if (secret) {
    stdin.echoMode = false;
  }
  
  var response = Terminal.readLine();
  if (secret) {
    print("");
  }
  return response;
}

/// Prompts a user for a yes or no answer.
/// 
/// The following are considered yes responses:
/// 
/// - yes
/// - y
/// - sure
/// - ok
/// - yep
/// - yeah
/// - true
/// - yerp
/// 
/// The input will be changed to lowercase and then checked.
bool yesOrNo(String message) {
  var answer = prompt(message);
  return _YES_RESPONSES.contains(answer.toLowerCase());
}

/// Emulates a Shell Prompt
class ShellPrompt {
  /// Shell Prompt
  String message;
  bool _stop = false;
  
  ShellPrompt({this.message: r"$ "});
  
  /// Reads a Single Line
  String read() {
    return prompt(message);
  }
  
  /// Stops a Loop
  void stop() {
    _stop = true;
  }
  
  /// Runs a shell prompt in a loop.
  Stream<String> loop() {
    var controller = new StreamController<String>();
    
    var doRead;
    
    doRead = () {
      if (_stop) {
        _stop = false;
        return;
      }
      var input = read();
      controller.add(input);
      new Future(doRead);
    };
    
    new Future(doRead);
    
    return controller.stream;
  }
}