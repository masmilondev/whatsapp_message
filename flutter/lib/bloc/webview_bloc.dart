import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:tawabel/utils/web_pages.dart';
import 'package:tawabel/utils/whatsapp_selectors.dart';
import 'package:webview_windows/webview_windows.dart';

class WebViewBloc extends ChangeNotifier {
  final WebviewController _controller = WebviewController();
  Map<dynamic, dynamic> _event = {};
  String? error;
  bool shouldOpenNewPage = false;
  bool busy = false;
  LoadingState currentLoadingState = LoadingState.none;
  String currentUrl = "";
  WebPages _pages = WebPages();

  WebviewController get controller => _controller;
  Map<dynamic, dynamic> get event => _event;

  Duration waitingTime = const Duration(milliseconds: 500);

  Future<void> _initialize() async {
    if (_controller.value.isInitialized) return;
    try {
      await _controller.initialize();

      if (_controller.hasListeners) return;

      _controller.webMessage.listen((event) {
        _event = event;
        print(event);
      });

      _controller.securityStateChanged.listen((event) {
        print(event);
      });

      _controller.historyChanged.listen((event) {
        // print(event);
      });

      _controller.loadingState.listen((loadingState) {
        print(loadingState);
        currentLoadingState = loadingState;
        if (loadingState == LoadingState.loading) {
          busy = true;
          notifyListeners();
        }
        if (loadingState == LoadingState.none ||
            loadingState == LoadingState.navigationCompleted) {
          busy = false;
          log("LoadingState: $loadingState");
          notifyListeners();
        }
      });

      _controller.url.listen((url) {
        currentUrl = url;
        log(currentUrl);
        // bool isConfirmation = currentUrl.contains(_pages.confirmation);
        // if (isConfirmation) {
        //   _controller.stop();
        // }
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> openIndianVisaSite() async {
    try {
      setBusy(true);
      print(_controller.value.isInitialized);
      if (!_controller.value.isInitialized) {
        await _initialize();
      }

      print(_controller.value.isInitialized);

      await _controller.resume();
      await _controller.stop();

      // // await _controller.loadUrl("https://google.com/");
      await _controller.loadUrl(_pages.homepage);
    } catch (e) {
      print(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> reloadPage() async {
    setBusy(true);
    _setError();
    await _controller.reload();

    setBusy(false);
  }

  void _setError([String? message]) {
    error = message;
    notifyListeners();
  }

  setBusy(bool _b) {
    busy = _b;
    log("is busy: $_b");
    notifyListeners();
  }

  Future<void> sendMessage() async {
    try {
      await execute(WhatsappSelectors.searchBox, "Hello");
    } catch (e) {
      print(e);
    }
  }

  Future<void> execute(
    String selector,
    dynamic value, {
    String? manualSelectorId,
    bool onChange = false,
    bool checkData = false,
    bool isRadio = false,
    bool isCheckbox = false,
    bool clickCheckbox = false,
  }) async {
    if ((manualSelectorId != null ||
            !onChange ||
            !checkData ||
            !isRadio ||
            !isCheckbox) &&
        value == null) {
      return;
    }

    String? s;
    if (manualSelectorId != null) {
      selector = "document.querySelector('#$manualSelectorId')";
    }
    if (isRadio) {
      s = "$selector.click()";
      // String click = "$selector.dispatchEvent(new Event('click'))";
      // String script = 'window.chrome.webview.postMessage($click)';
      // await _controller.executeScript(script);
    } else {
      s = "$selector.value = '$value'";
    }

    if (isCheckbox) {
      s = "$selector.checked = '$value'";
    }

    if (clickCheckbox) {
      if (value == true) {
        s = "$selector.click()";
      }
    }

    String script = 'window.chrome.webview.postMessage($s)';
    await _controller.executeScript(script);

    if (checkData) {
      int count = 10;
      for (var i = 0; i < count; i++) {
        await Future.delayed(waitingTime);
        bool response = await _checkData(selector, value);
        if (response) {
          break;
        }
      }
    }

    if (onChange) {
      String change = "$selector.dispatchEvent(new Event('change'))";
      script = 'window.chrome.webview.postMessage($change)';
      await _controller.executeScript(script);
    }
  }

  Future<bool> _checkData(
    String selector,
    dynamic value,
  ) async {
    String s = "$selector.value = '$value'";
    String script = 'window.chrome.webview.postMessage($s)';
    await _controller.executeScript(script);

    script = 'window.chrome.webview.postMessage({data: $selector.value})';
    await _controller.executeScript(script);
    try {
      if (event.containsKey('data')) {
        if (event['data'].toString() == value.toString()) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
