extends Node2D

# IDs reservados para teste
var adBannerId = "ca-app-pub-3940256099942544/6300978111"
var adInterstitialId = "ca-app-pub-3940256099942544/1033173712" 
var adRewardedId = "ca-app-pub-3940256099942544/8691691433" 

var admob = null
var isReal = false
var isTop = true
var debug = null
var isbieunguloaded = false
var istrunggianloaded = false

func _ready():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()
		loadInterstitial()
		loadRewardedVideo()
	
	debug = get_node("canvas_layer/debug")
	get_tree().connect("screen_resized", self, "on_resize")

# LOADERS

func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)

func loadInterstitial():
	if admob != null:
		admob.loadInterstitial(adInterstitialId)

func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)

# EVENTS

func _on_btn_banner_toggled(pressed):
	if admob != null:
		if pressed: admob.showBanner()
		else: admob.hideBanner()

func _on_btn_interstitial_pressed():
	if admob != null:
		admob.showInterstitial()

func _on_btn_rewarded_video_pressed():
	if admob != null:
		admob.showRewardedVideo()

func _on_admob_network_error():
	debug.text = "Network Error"
	
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()

func _on_admob_ad_loaded():
	debug.text = "Banner loaded success"
	get_node("canvas_layer/btn_banner").set_disabled(false)

func _on_interstitial_not_loaded():
	debug.text = "Error: Interstitial not loaded"
	
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadInterstitial()

func _on_interstitial_loaded():
	debug.text = "Interstitial loaded success"
	get_node("canvas_layer/btn_interstitial").set_disabled(false)

func _on_interstitial_close():
	debug.text = "Interstitial closed"
	get_node("canvas_layer/btn_interstitial").set_disabled(true)

func _on_rewarded_video_ad_loaded():
	debug.text = "Rewarded loaded success"
	get_node("canvas_layer/btn_rewarded_video").set_disabled(false)

func _on_rewarded_video_ad_closed():
	debug.text = "Rewarded closed"
	get_node("canvas_layer/btn_rewarded_video").set_disabled(true)
	loadRewardedVideo()

func _on_rewarded(currency, amount):
	debug.text = "Reward: " + currency + ", " + str(amount)
	get_node("canvas_layer/lbl_rewarded").set_text("Reward: " + currency + ", " + str(amount))

# RESIZE

func on_resize():
	if admob != null:
		admob.resize()