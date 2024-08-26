import 'package:dio/dio.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:graphics_news/network/common/common_dto.dart';
import 'package:graphics_news/network/entity/album/album_listing.dart';
import 'package:graphics_news/network/entity/album/gallery_listing.dart';
import 'package:graphics_news/network/entity/archives/archives_dto.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf_response.dart';
import 'package:graphics_news/network/entity/historydownload/download_history.dart';
import 'package:graphics_news/network/entity/markDownload/mark_download_resp.dart';
import 'package:graphics_news/network/entity/payment/paystack_init.dart';
import 'package:graphics_news/network/entity/preference_dto.dart';
import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';
import 'package:graphics_news/network/entity/videolisting/video_res_list.dart';
import 'package:graphics_news/network/response/aboutus_response.dart';
import 'package:graphics_news/network/response/all_coupons_response.dart';
import 'package:graphics_news/network/response/bookmark_new_response.dart';
import 'package:graphics_news/network/response/bookmark_response.dart';
import 'package:graphics_news/network/response/category_listing_response.dart';
import 'package:graphics_news/network/response/contactUsResponse.dart';
import 'package:graphics_news/network/response/forget_response.dart';
import 'package:graphics_news/network/response/gallery_listing_response.dart';
import 'package:graphics_news/network/response/grid_collection_response.dart';
import 'package:graphics_news/network/response/heard_from_response.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/response/instagram_response.dart';
import 'package:graphics_news/network/response/logout_response.dart';
import 'package:graphics_news/network/response/magazine_detail_pdf_response.dart';
import 'package:graphics_news/network/response/news_listing_response.dart';
import 'package:graphics_news/network/response/podcast_detail_response.dart';
import 'package:graphics_news/network/response/podcasts_response.dart';
import 'package:graphics_news/network/response/promoted_detail_response.dart';
import 'package:graphics_news/network/response/promoted_listing_response.dart';
import 'package:graphics_news/network/response/publications_response.dart';
import 'package:graphics_news/network/response/search_response.dart';
import 'package:graphics_news/network/response/set_coupon_response.dart';
import 'package:graphics_news/network/response/subscription_response.dart';
import 'package:graphics_news/network/response/topics_detail_response.dart';
import 'package:graphics_news/network/response/topics_listing_response.dart';
import 'package:graphics_news/network/response/video_detail_response.dart';
import 'package:retrofit/http.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: RestPath.BASE_URL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(RestPath.AUTH_LOGIN)
  Future<AuthDTO> getLogin(
    @Field() String email,
    @Field() String password,
    @Field() String deviceId,
    @Field() String platform,
  );

  @POST(RestPath.AUTH_SOCIAL_LOGIN)
  Future<AuthDTO> getSociallogin(
    @Field() String name,
    @Field() String email,
    @Field() String socialId,
    @Field() String platform,
    @Field() String deviceId,
    @Field() String country,
    @Field() String dob,
    @Field() String gender,
    @Field() String phone,
    @Field() String referredFrom,
    @Field() String referCode,
  );

  @POST(RestPath.REGISTER)
  Future<AuthDTO> getRegister(
      @Field() String name,
      @Field() String email,
      @Field() String password,
      @Field() String phone,
      @Field() String dob,
      @Field() String country,
      @Field() String deviceId,
      @Field() String referredFrom,
      @Field() String referCode,
      @Field() String gender);

  @GET(RestPath.HEARD_FROM)
  Future<HeardFromResponse> getHeardFromList();

  @GET(RestPath.HOME_PAGE)
  Future<HomeResponse> getHomePage();

  @POST(RestPath.NEWS_MAG_LISTING) //getting the mag and news by type
  Future<NewsListingResponse> getNewsMagListingPage(
      @Field() int categoryId,
      @Field() int publicationId,
      @Field() String from,
      @Field() String type,
      @Field() int page);

  @GET(RestPath.CATEGORY_LISTING) //this one amit
  Future<CategoryListingResponse> getCategoryListingPage();

  @GET(RestPath.TOPICS_LISTING)
  Future<TopicsListingResponse> getTopicsListingPage();

  @GET(RestPath.PROMOTED_LISTING)
  Future<PromotedListingResponse> getPromotedListingPage(
      @Query("page") int page);

  @GET(RestPath.TOP_STORIES_LISTING)
  Future<PromotedListingResponse> getTopStoriesListingPage(
      @Query("page") int page);

  @GET("${RestPath.TOPICS_DETAILS}/{id}/details")
  Future<TopicsDetailResponse> getTopicsDetailPage(@Path("id") int id);

  @GET("${RestPath.CATEGORY_DETAILS}/{id}/popular_categories_details")
  Future<CategoryListingResponse> getCategoryDetailPage(@Path("id") int id);

  @GET("${RestPath.TOP_STORIES_DETAILS}/{id}/view")
  Future<PromotedDetailResponse> getTopStoryDetailPage(@Path("id") int id);

  @GET("${RestPath.PROMOTED_CONTENT_DETAILS}/{id}/view")
  Future<PromotedDetailResponse> getPromotedContentDetailPage(
      @Path("id") int id);

  @GET("${RestPath.MAGAZINES_DETAILS}/{id}/view")
  Future<MagazineDetailPdfResponse> getMagazineDetailPage(
      @Path("id") int id, @Query("base") String base);

  @GET("${RestPath.NEWSPAPER_DETAILS}/{id}/view")
  Future<MagazineDetailPdfResponse> getNewsPaperDetailPage(
      @Path("id") int id, @Query("base") String base);

  @GET(RestPath.GALLERY_LISTING)
  Future<GalleryListingResponse> getGalleryListingPage();

  @POST(RestPath.LOGOUT)
  Future<LogoutResponse> getLogout();

  @POST(RestPath.DELETE_ACCOUNT)
  Future<LogoutResponse> getDeleteAccount();

  @GET("${RestPath.MAGAZINES_DETAILS}/{id}/pdf")
  Future<DataPdfResponse> getMagazineDetailDownloadPdf(@Path("id") int id);

  @GET("${RestPath.MAGAZINES_DETAILS}/{id}/mark_as_downloaded")
  Future<MarkDownloadResponse> getMagazineMarkAsDownload(@Path("id") int id);

  @GET("${RestPath.NEWSPAPER_DETAILS}/{id}/pdf")
  Future<DataPdfResponse> getNewsPaperDetailDownloadPdf(@Path("id") int id);

  @GET("${RestPath.NEWSPAPER_DETAILS}/{id}/mark_as_downloaded")
  Future<MarkDownloadResponse> getNewsPaperMarkAsDownload(@Path("id") int id);

  @POST(RestPath.FORGET_PASSWORD)
  Future<ForgetResponse> forgetPassword(@Field() String email);

  @POST(RestPath.CHANGE_PASSWORD)
  Future<ForgetResponse> changePassword(@Field() int id,
      @Field() String oldPassword, @Field() String newPassword);

  @GET(RestPath.PODCASTS_LISTING)
  Future<PodCastsResponse> getPodcastsListing(@Query("page") int page);

  @GET(RestPath.ABOUT_US)
  Future<AboutUsResponse> aboutUs();

  @GET(RestPath.VIDEOS_LISTING)
  Future<VideoResponseList> getVideosListing(@Query("page") int page);

  @POST(RestPath.CONTACT_US)
  Future<ContactUsResponse> contactUs(
    @Field() int userId,
    @Field() String fullName,
    @Field() String email,
    @Field() String subject,
    @Field() String feedback,
  );

  @GET(RestPath.SUBSCRIPTION_ALL_PLANS)
  Future<SubscriptionDTO> getSubscriptionPlan();

  @POST(RestPath.PAYSTACK_INIT)
  Future<PayStackInit> getPayStackInit(
      @Field() List<int> packageKey,
      @Field() String durationKey,
      @Field() String isFamily,
      @Field() String coupon,
      @Field() int renew,
      @Field() String paymentMethod);

  @POST(RestPath.PAYSTACK_VERIFY)
  Future<CommonDTO> PayStackVerify(
    @Field() String reference,
    @Field() String paymentMethod,
    @Field() String? appleProductId,
    @Field() String? purchaseId,
    @Field() String? isFamily,
  );

  @GET(RestPath.MY_SUBSCRIPTIONS)
  Future<SubscriptionResponse> getMySubscriptions();

  @POST(RestPath.REFERRAL_PLAN)
  Future<CommonDTO> getReferralPlan(@Field() String referralCode);

  @POST(RestPath.SET_BOOKMARK)
  Future<CommonDTO> setBookMark(@Field() int id, @Field() String type);

  @POST(RestPath.SAVED_PREFERENCE)
  Future<CommonDTO> savedPreference(@Field() List<int> topics);

  @POST(RestPath.SAVED_Notification)
  Future<CommonDTO> savedNotification(@Field() String pushNotification);

  @GET(RestPath.GET_BOOKMARKS)
  Future<BookMarkResponse> getBookMarks();

  @GET(RestPath.GET_BOOKMARKS_NEW)
  Future<BookMarkNewResponse> getBookMarksNew();

  @GET(RestPath.GET_ALL_COUPONS)
  Future<AllCouponsResponse> getAllCoupons();

  @POST(RestPath.HOME_SEARCH)
  Future<SearchResponse?> homeSearch(@Field() String search);

  @POST(RestPath.GET_ALL_PUBLICATIONS)
  Future<PublicationsResponse?> getPublicationslistApi(
      @Field() int categoryId, @Field() String type);

  @GET(RestPath.GET_DOWNLOAD_HISTORY)
  Future<DownloadHistory> downloadHistory();

  @POST(RestPath.UPDATE_PROFILE)
  Future<CommonDTO> updateProfile(
      @Field() String firstName,
      @Field() String lastName,
      @Field() country,
      @Field() dob,
      @Field() gender);

  @POST(RestPath.PAYSTACK_SINGLE_PLAN_INIT)
  Future<PayStackInit> getSinglePayStackInit(
      @Field() String key,
      @Field() String type,
      @Field() reference,
      @Field() String coupon,
      @Field() String paymentMethod);

  @POST(RestPath.APPLY_COUPON)
  Future<SetCouponResponse> applyCoupon(
      @Field() String code, @Field() String amount);

  @POST(RestPath.REMOVE_COUPON)
  Future<SetCouponResponse> removeCoupon(@Field() String code);

  @GET(RestPath.PRIVACY)
  Future<AboutUsResponse> privacy();

  @GET(RestPath.LICNECES)
  Future<AboutUsResponse> policiesandlicences();

  @GET(RestPath.COURTESIES)
  Future<AboutUsResponse> courtesies();

  @GET(RestPath.FAQ)
  Future<AboutUsResponse> faq();

  @GET(RestPath.INTAGRAM)
  Future<InstagramResponse> instagramList();

  @POST(RestPath.SUBSCRIPTION_REFUND)
  Future<CommonDTO> SubscriptionRefund(
      @Field() int referenceId, @Field() String reason);

  @POST(RestPath.SET_EVENT)
  Future<CommonDTO> setEvent(
      @Field() String type, @Field() String clickType, @Field() int? fileId);

  @GET(RestPath.PREFERENCE_SETTING)
  Future<PerferenceDTO> getPreferenceList();

  @GET(RestPath.ALBUM_LISTING)
  Future<AlbumListingDTO> getAlbumList(@Query("page") int page);

  @GET(RestPath.GALLERY_LISTING_BY_ID)
  Future<GalleryListingDTO> getGalleryById(
      @Query("album_id") int albumId, @Query("page") int page);

  @POST(RestPath.VIDEO_DETAILS)
  Future<VideoDetailResponse> getVideo_detail(@Field() int id);

  @POST(RestPath.GRID_COLLECTION)
  Future<GridCollectionResponse> gridCollection(
      @Field() int key, @Field() String type);

  @POST(RestPath.PODCAST_DETAILS)
  Future<PodcastDetailResponse> podcastDetail(@Field() int id);

  @POST(RestPath.ARCHIVE)
  Future<ArchivesDTO> archiveListing(@Field() int publication,
      @Field() String date, @Field() int page, @Field() String type);

  @POST(RestPath.TOPIC_TO_FOLLOW_LISTING)
  Future<CategoryListingResponse> getTopicFollowListingPage(
      @Field() int categoryId, @Field() int page, @Field() String type);
}
