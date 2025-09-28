// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpClientHash() => r'8c21f22632338286954dc297d3cf423520492f98';

/// See also [httpClient].
@ProviderFor(httpClient)
final httpClientProvider = AutoDisposeProvider<http.Client>.internal(
  httpClient,
  name: r'httpClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$httpClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpClientRef = AutoDisposeProviderRef<http.Client>;
String _$youTubeServiceHash() => r'f90e014afa95c71f35d7ef678dd788c3b740cbfe';

/// See also [youTubeService].
@ProviderFor(youTubeService)
final youTubeServiceProvider =
    AutoDisposeFutureProvider<YouTubeService>.internal(
      youTubeService,
      name: r'youTubeServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$youTubeServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef YouTubeServiceRef = AutoDisposeFutureProviderRef<YouTubeService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
