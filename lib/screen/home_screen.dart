import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_movieapp_module/model/genre_model.dart';
import 'package:riverpod_movieapp_module/model/popular_movies_model.dart';
import 'package:riverpod_movieapp_module/provider/genre_change_notifier.dart';
import 'package:riverpod_movieapp_module/provider/providers.dart';
import 'package:riverpod_movieapp_module/screen/description_screen.dart';
import 'package:riverpod_movieapp_module/screen/search_screen.dart';
import 'package:riverpod_movieapp_module/screen/see_all_screen.dart';
import 'package:riverpod_movieapp_module/widget/common_component.dart';
import 'package:riverpod_movieapp_module/widget/styles.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedGenreId() {
    if (ref.watch(genreNotifierProvider).genreBoolean.isNotEmpty) {
      int index = ref.watch(genreNotifierProvider).genreBoolean.indexOf(true);
      int genreID = Genres().genres[index].id;
      return genreID;
    } else {
      return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedGenreNotifier = ref.watch(genreNotifierProvider);
    // late FavouriteStateNotifier favouriteflagNotifier;
    // final favouriteflagNotifier = ref.watch(favouriteNotifierProvider.notifier);

    return Scaffold(
      body: _body(context, selectedGenreNotifier),
    );
  }

  SingleChildScrollView _body(
    BuildContext context,
    GenreChangeNotifier selectedGenreNotifier,
  ) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFF1F2340),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 35),
              child: _customAppbar(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  _headerTextWidget(context, 'Popular Movies'),
                  const Spacer(),
                  Baseline(
                    baseline: 18,
                    baselineType: TextBaseline.alphabetic,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SeeAllScreen()));
                      },
                      child: Text('See all', style: Styles.style1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ref.watch(popularMoviesFutureProvider).when(
                  data: (data) => _popularMoviesDataContainer(context, data),
                  error: (e, s) => Text(e.toString()),
                  loading: () => _popularMoviesLoaderWidget(context),
                ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: _headerTextWidget(context, 'Genres'),
            ),
            _genresLableContainer(selectedGenreNotifier),
            ref.watch(genreBasedMoviesFutureProvider(selectedGenreId())).when(
                  data: (data) => _genreBasedMovieDataContainer(context, data),
                  error: (e, s) => Text(e.toString()),
                  loading: () => _genreBasedMovieLoaderWidget(context),
                ),
          ],
        ),
      ),
    );
  }

  SizedBox _genreBasedMovieLoaderWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 60,
            ),
            Center(child: CircularProgressIndicator()),
          ],
        ));
  }

  SizedBox _popularMoviesLoaderWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        width: double.infinity,
        child: const Center(child: CircularProgressIndicator()));
  }

  LimitedBox _genreBasedMovieDataContainer(BuildContext context, Movies data) {
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.height * 5,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 15, bottom: 30, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: min(data.results!.length, 10),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DescriptionScreen(
                            movieID: data.results![index].id,
                            favouriteStateNotifier: ref.watch(data
                                .results![index]
                                .favouriteNotifierProvider
                                .notifier),
                            favouriteNotifierProvider:
                                data.results![index].favouriteNotifierProvider,
                          )));
                },
                child: SizedBox(
                  height: 220,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: const Color(0xFF12172E),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          height: 220,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            child: Image.network(
                              data.results![index].fullImageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.38 -
                                80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .watch(data
                                                .results![index]
                                                .favouriteNotifierProvider
                                                .notifier)
                                            .onTap();
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: ref
                                                .watch(data.results![index]
                                                    .favouriteNotifierProvider)
                                                .favouriteFlag
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      MediaQuery.of(context).size.width * 0.38 -
                                      90,
                                  child: Text(
                                      data.results![index].originalTitle
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.style2),
                                ),
                                _ratingStarWidget(data, index, context),
                                Text(
                                    ref.read(getGenres(
                                        data.results![index].genreIds)),
                                    maxLines: null,
                                    style: Styles.style3),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Padding _ratingStarWidget(Movies data, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 110,
        child: Row(
          children: List.generate(6, (index1) {
            double rating = (5 * data.results![index].voteAverage! * 10) / 100;
            return CommonComponent.getRating(context, index1, rating);
          }),
        ),
      ),
    );
  }

  SizedBox _genresLableContainer(GenreChangeNotifier selectedGenreNotifier) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: Genres().genres.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                selectedGenreNotifier.setSelectedGenre(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: selectedGenreNotifier.genreBoolean.isNotEmpty
                      ? selectedGenreNotifier.genreBoolean[index]
                          ? const Color(0xFF127ADA)
                          : const Color(0xFF12172E)
                      : index == 0
                          ? const Color(0xFF127ADA)
                          : const Color(0xFF12172E),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Text(Genres().genres[index].name,
                    maxLines: 1, style: Styles.style4),
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox _popularMoviesDataContainer(BuildContext context, Movies data) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: min(data.results!.length, 10),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DescriptionScreen(
                                  movieID: data.results![index].id,
                                  favouriteStateNotifier: ref.watch(data
                                      .results![index]
                                      .favouriteNotifierProvider
                                      .notifier),
                                  favouriteNotifierProvider: data
                                      .results![index]
                                      .favouriteNotifierProvider,
                                )),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          child: Image.network(
                            data.results![index].fullImageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4 - 10,
                    child: Text(data.results![index].originalTitle.toString(),
                        maxLines: null, style: Styles.style5),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                        ref.read(getGenres(data.results![index].genreIds)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.style6),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Text _headerTextWidget(BuildContext context, String text) {
    return Text(text,
        maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.style7);
  }

  Row _customAppbar(BuildContext context) {
    return Row(
      children: [
        CommonComponent.iconCard(context, Icons.view_headline_rounded),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const SearchScreen()));
          },
          child: CommonComponent.iconCard(context, Icons.search),
        ),
        CommonComponent.iconCard(context, Icons.notifications)
      ],
    );
  }
}
