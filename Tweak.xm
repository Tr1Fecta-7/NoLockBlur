
@interface SBFWallpaperView : UIView // iOS 7-13
-(UIImage *)wallpaperImage;
@end

@interface SBWallpaperController: NSObject // iOS 7-13
@property (nonatomic,retain) SBFWallpaperView * sharedWallpaperView;                                          //@synthesize sharedWallpaperView=_sharedWallpaperView - In the implementation block
@property (nonatomic,retain) SBFWallpaperView * lockscreenWallpaperView;                                      //@synthesize lockscreenWallpaperView=_lockscreenWallpaperView - In the implementation block
@property (nonatomic,retain) SBFWallpaperView * homescreenWallpaperView;                                      //@synthesize lockscreenWallpaperView=_lockscreenWallpaperView - In the implementation block

-(UIImage *)getLockWallpaper;
-(void)saveWallpaper;
+(id)sharedInstance;
@end

@interface SBDashBoardPasscodeBackgroundView : UIView // iOS 12
-(UIImage *)getLockWallpaper;
@end

@interface CSPasscodeBackgroundView : UIView // iOS 13+
-(UIImage *)getLockWallpaper;
@end



%group iOS12TWEAK
		
%hook SBDashBoardPasscodeBackgroundView

%new
-(UIImage *)getLockWallpaper {    
  	SBWallpaperController* controller = [%c(SBWallpaperController) sharedInstance];
	SBFWallpaperView* wallpaperView = controller.sharedWallpaperView ? controller.sharedWallpaperView : controller.lockscreenWallpaperView; // Change lockscreenWallpaperView to homescreenWallpaperView depepnding on which you want (if user isnt using the image as both)
	return wallpaperView.wallpaperImage;
}

-(instancetype)initWithFrame:(CGRect)frame {
	if ((self = %orig)) {
		UIImageView *wallpaperView = [[UIImageView alloc] initWithImage:[self getLockWallpaper]];
		wallpaperView.frame = [UIScreen.mainScreen bounds];
        [wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
        wallpaperView.clipsToBounds = YES;
		[self addSubview:wallpaperView];
	}
	return self;
}

%end
%end


%group iOS13TWEAK 

%hook CSPasscodeBackgroundView

%new
-(UIImage *)getLockWallpaper {    
  	SBWallpaperController* controller = [%c(SBWallpaperController) sharedInstance];
	SBFWallpaperView* wallpaperView = controller.sharedWallpaperView ? controller.sharedWallpaperView : controller.lockscreenWallpaperView; // Change lockscreenWallpaperView to homescreenWallpaperView depepnding on which you want (if user isnt using the image as both)
	return wallpaperView.wallpaperImage;
}

-(instancetype)initWithFrame:(CGRect)frame {
	if ((self = %orig)) {
		UIImageView *wallpaperView = [[UIImageView alloc] initWithImage:[self getLockWallpaper]];
		wallpaperView.frame = [UIScreen.mainScreen bounds];
        [wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
        wallpaperView.clipsToBounds = YES;
		[self addSubview:wallpaperView];
	}
	return self;
}

%end

%end

%ctor {
	if (@available(iOS 13, *)) {
		%init(iOS13TWEAK);
	}
	else if (@available(iOS 12, *)) {
		%init(iOS12TWEAK);
	}
}

