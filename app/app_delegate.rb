class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    # Parse.setApplicationId "XXXX",
    #   clientKey: "YYYY"

    Task.loadTasks

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    morph_controller = MorphController.alloc.initWithNibName(nil, bundle: nil)

    @window.rootViewController = morph_controller

    true
  end
end
