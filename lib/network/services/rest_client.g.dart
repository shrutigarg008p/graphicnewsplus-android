// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    // baseUrl ??= 'https://gcgl.dci.in/public/api/';
    baseUrl ??= RestPath.BASE_URL;
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AuthDTO> getLogin(email, password, deviceId, platform) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'platform': platform
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'auth/login',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AuthDTO> getSociallogin(name, email, socialId, platform, deviceId,
      country, dob, gender, phone, referredFrom, referCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'name': name,
      'email': email,
      'social_id': socialId,
      'platform': platform,
      'device_id': deviceId,
      'country': country,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'referred_from': referredFrom,
      'refer_code': referCode
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'auth/social_login',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AuthDTO> getRegister(name, email, password, phone, dob, country,
      deviceId, referredFrom, referCode, gender) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'dob': dob,
      'country': country,
      'device_id': deviceId,
      'referred_from': referredFrom,
      'refer_code': referCode,
      'gender': gender
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'auth/registerCustomer',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HeardFromResponse> getHeardFromList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HeardFromResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'auth/heard_from_list',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = HeardFromResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HomeResponse> getHomePage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HomeResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/home',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = HomeResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NewsListingResponse> getNewsMagListingPage(
      categoryId, publicationId, from, type, page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'category_id': categoryId,
      'publication_id': publicationId,
      'from': from,
      'type': type,
      'page': page
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NewsListingResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/newspapers',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NewsListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CategoryListingResponse> getCategoryListingPage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CategoryListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/category/all_category_listing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoryListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TopicsListingResponse> getTopicsListingPage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TopicsListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/tags/listing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TopicsListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PromotedListingResponse> getPromotedListingPage(page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PromotedListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'customer/blogs/promoted_content/listing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PromotedListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PromotedListingResponse> getTopStoriesListingPage(page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PromotedListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/blogs/top_story/listing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PromotedListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TopicsDetailResponse> getTopicsDetailPage(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TopicsDetailResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/tags/${id}/details',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TopicsDetailResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CategoryListingResponse> getCategoryDetailPage(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CategoryListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'customer/category/${id}/popular_categories_details',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoryListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PromotedDetailResponse> getTopStoryDetailPage(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PromotedDetailResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/blogs/top_story/${id}/view',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PromotedDetailResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PromotedDetailResponse> getPromotedContentDetailPage(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PromotedDetailResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'customer/blogs/promoted_content/${id}/view',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PromotedDetailResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MagazineDetailPdfResponse> getMagazineDetailPage(id, base) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'base': base};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MagazineDetailPdfResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/magazines/${id}/view',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MagazineDetailPdfResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MagazineDetailPdfResponse> getNewsPaperDetailPage(id, base) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'base': base};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MagazineDetailPdfResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/newspapers/${id}/view',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MagazineDetailPdfResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GalleryListingResponse> getGalleryListingPage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GalleryListingResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/gallery',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GalleryListingResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LogoutResponse> getLogout() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LogoutResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'auth/logout',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LogoutResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LogoutResponse> getDeleteAccount() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LogoutResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/delete_account',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LogoutResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DataPdfResponse> getMagazineDetailDownloadPdf(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DataPdfResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/magazines/${id}/pdf',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DataPdfResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MarkDownloadResponse> getMagazineMarkAsDownload(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MarkDownloadResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'customer/magazines/${id}/mark_as_downloaded',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MarkDownloadResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DataPdfResponse> getNewsPaperDetailDownloadPdf(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DataPdfResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/newspapers/${id}/pdf',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DataPdfResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MarkDownloadResponse> getNewsPaperMarkAsDownload(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MarkDownloadResponse>(Options(
                method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'customer/newspapers/${id}/mark_as_downloaded',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MarkDownloadResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgetResponse> forgetPassword(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/sendresetlink',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgetResponse> changePassword(id, oldPassword, newPassword) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'id': id,
      'oldPassword': oldPassword,
      'newPassword': newPassword
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgetResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/changepassword',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgetResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PodCastsResponse> getPodcastsListing(page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PodCastsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/podcasts',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PodCastsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AboutUsResponse> aboutUs() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AboutUsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/aboutus',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AboutUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VideoResponseList> getVideosListing(page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VideoResponseList>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/videos',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VideoResponseList.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContactUsResponse> contactUs(
      userId, fullName, email, subject, feedback) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'subject': subject,
      'feedback': feedback
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContactUsResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/contactus',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContactUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SubscriptionDTO> getSubscriptionPlan() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SubscriptionDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/all_plans',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SubscriptionDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PayStackInit> getPayStackInit(
      packageKey, durationKey, isFamily, coupon, renew, paymentMethod) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'package_key': packageKey,
      'duration_key': durationKey,
      'is_family': isFamily,
      'coupon': coupon,
      'renew': renew,
      'payment_method': paymentMethod
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PayStackInit>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/paystack_new_plan',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PayStackInit.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> PayStackVerify(
      reference, paymentMethod, appleProductId, purchaseId, isFamily) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'reference': reference,
      'payment_method': paymentMethod,
      'apple_product_id': appleProductId,
      'purchase_id': purchaseId,
      'is_family': isFamily
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/paystack_verify',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SubscriptionResponse> getMySubscriptions() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SubscriptionResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/my_subscriptions',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SubscriptionResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> getReferralPlan(referralCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'referral_code': referralCode};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/referral_new_plan',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> setBookMark(id, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'id': id, 'type': type};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/set_bookmark',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> savedPreference(topics) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'topics': topics};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/save_topics',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> savedNotification(pushNotification) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'push_notification': pushNotification};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/settings',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookMarkResponse> getBookMarks() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BookMarkResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/get_bookmarks',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookMarkResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookMarkNewResponse> getBookMarksNew() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BookMarkNewResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/get_bookmarks2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookMarkNewResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AllCouponsResponse> getAllCoupons() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AllCouponsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/coupons',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AllCouponsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchResponse?> homeSearch(search) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'search': search};
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<SearchResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/home-search2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        _result.data == null ? null : SearchResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PublicationsResponse?> getPublicationslistApi(categoryId, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'category_id': categoryId, 'type': type};
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<PublicationsResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/publication_list',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : PublicationsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DownloadHistory> downloadHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DownloadHistory>(Options(
                method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'user_downloads1' /*'customer/user_downloads1'*/,
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DownloadHistory.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> updateProfile(
      firstName, lastName, country, dob, gender) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'first_name': firstName,
      'last_name': lastName,
      'country': country,
      'dob': dob,
      'gender': gender
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/profile_update',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PayStackInit> getSinglePayStackInit(
      key, type, reference, coupon, paymentMethod) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'key': key,
      'type': type,
      'reference': reference,
      'coupon': coupon,
      'payment_method': paymentMethod
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PayStackInit>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/premium_content/buy',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PayStackInit.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SetCouponResponse> applyCoupon(code, amount) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code, 'amount': amount};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SetCouponResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/coupons/applyCoupon',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SetCouponResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SetCouponResponse> removeCoupon(code) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SetCouponResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/coupons/removeCoupon',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SetCouponResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AboutUsResponse> privacy() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AboutUsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/privacyPolicy',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AboutUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AboutUsResponse> policiesandlicences() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AboutUsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/policiesandlicences',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AboutUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AboutUsResponse> courtesies() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AboutUsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/courtesies',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AboutUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AboutUsResponse> faq() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AboutUsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/faq',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AboutUsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<InstagramResponse> instagramList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<InstagramResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/instagramData',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = InstagramResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> SubscriptionRefund(referenceId, reason) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'reference_id': referenceId, 'reason': reason};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/subscription_refund',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommonDTO> setEvent(type, clickType, fileId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'type': type, 'click_type': clickType, 'file_id': fileId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/getactivity_event',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PerferenceDTO> getPreferenceList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PerferenceDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/getPreferences',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PerferenceDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AlbumListingDTO> getAlbumList(page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AlbumListingDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/gallery/albumListing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AlbumListingDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GalleryListingDTO> getGalleryById(albumId, page) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'album_id': albumId,
      r'page': page
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GalleryListingDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/gallery/galleryListing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GalleryListingDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VideoDetailResponse> getVideo_detail(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'id': id};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VideoDetailResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/videos/detail',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VideoDetailResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GridCollectionResponse> gridCollection(key, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'key': key, 'type': type};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GridCollectionResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/grid_collection',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GridCollectionResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PodcastDetailResponse> podcastDetail(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'id': id};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PodcastDetailResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/podcasts/detail',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PodcastDetailResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ArchivesDTO> archiveListing(publication, date, page, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'publication': publication,
      'date': date,
      'page': page,
      'type': type
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ArchivesDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/archive/listing',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ArchivesDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CategoryListingResponse> getTopicFollowListingPage(
      categoryId, page, type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'category_id': categoryId, 'page': page, 'type': type};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CategoryListingResponse>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'customer/topics_to_follow',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoryListingResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
