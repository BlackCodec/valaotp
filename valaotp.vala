namespace ValaOtp {
  public class ValaOtp : GLib.Object {
    
    private static bool debug=false;
    private static string me="valaotp";
    
    public static int main(string[] args) {
      ValaOtp.me=args[0];
      if ( args.length == 1) {
        ValaOtp.help();
        return 1;
      }
      try {
        Regex regex = new Regex("otpauth://(totp|hotp)/(.*)\\?(.*)");
        Regex short = new Regex("//(totp|hotp)/(.*)\\?(.*)");
        bool isfull = true;
        string url = "";
        for (int i = 0; i < args.length; i++) {
          if (args[i] == "-h" || args[i] == "--help" ) {
            ValaOtp.help();
            return 0;
          } else if (args[i] == "-d" || args[i] == "--debug" ) {
            ValaOtp.debug = true;
            ValaOtp.print("Debug mode enabled");
          } else if (regex.match(args[i])) {
            url = args[i];
          } else if (short.match(args[i])) {
            url = args[i];
            isfull = false;
          }
          ValaOtp.print("Parameter %d: %s".printf(i,args[i]));
        }
        ValaOtp.print("Read URL from args: %s".printf(url)); 
        if (url == "") {
          stdout.printf("Invalid otp url format");
          return 2;
        }
        string work_url = url;
        string secret = "";
        string method = "totp";
        string digits = "6";
        string period = "60";
        string algo = "sha1";
        string[] url_splitted;
        if (isfull) url_splitted = regex.split(work_url);
        else url_splitted = short.split(work_url);
        method = url_splitted[1];
        ValaOtp.print("Method: %s".printf(method));
        work_url=url_splitted[3];
        ValaOtp.print("New Url: %s".printf(work_url));
        string[] work_splitted = work_url.split("&");
        for (int i = 0; i < work_splitted.length; i++) {
          ValaOtp.print("Analyze record: %s".printf(work_splitted[i]));
          string[] key_val = work_splitted[i].split("=");
          string key = key_val[0];
          string value = key_val[1];
          if (key == "secret") {
            secret = value;
          } else if (key == "period") {
            period = value;
          } else if (key == "digits") {
            digits = value;
          } else if (key == "algorithm") {
            algo = value.down();
          } else {
            ValaOtp.print("Ignore key %s: %s".printf(key,value));
          }
        }
        ValaOtp.print("URL: %s".printf(url));
        ValaOtp.print("Work URL: %s".printf(work_url));
        ValaOtp.print("Method: %s".printf(method));
        ValaOtp.print("Digits: %s".printf(digits));
        ValaOtp.print("Period: %s".printf(period));
        ValaOtp.print("Algorith: %s".printf(algo));
        ValaOtp.print("Secret: %s".printf(secret));
        if (secret != "") {
          secret = Uri.unescape_string(secret);
          ValaOtp.print("Secret: %s".printf(secret));
          string method_ext = "%s=%s".printf(method,algo);
          if (method == "hotp") {
            method_ext = "htop";
          }
          string command_to_exec="oathtool -b --%s --digits=%s --time-step-size=%s %s".printf(method_ext,digits,period, secret);
          ValaOtp.print("Execute command: %s".printf(command_to_exec));
          string command_result;
          Process.spawn_command_line_sync (command_to_exec, out command_result);
          ValaOtp.print("Result: %s".printf(command_result));
          stdout.printf(command_result);
          return 0;
        }
        stdout.printf("Invalid secret");
        return 3;
      } catch (RegexError e) {
        stdout.printf("RegexError %s\n", e.message);
        return 5;
      } catch (SpawnError e) {
        stdout.printf("SpawnError %s\n", e.message);
        return 6;
      }
    }
    
    private static void print(string text) {
      if (ValaOtp.debug) {
        stdout.printf("[%s] %s\n",new DateTime.now_local().to_string(),text);
      }
    }
    
    private static void help() {
      stdout.printf("Usage %s [option] <otpauth>\n\nOptions:\n -h, --help: Print this message\n -d, --debug: Enable debug\n".printf(ValaOtp.me));
    }
  }
}