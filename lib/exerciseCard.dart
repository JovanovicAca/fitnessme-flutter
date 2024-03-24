import 'package:fitnessapp/model/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isExpanded = false;
  YoutubePlayerController? controller;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {
    String? videoId = YoutubePlayer.convertUrlToId(widget.exercise.link);
    if (videoId != null) {
      controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(ExerciseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exercise.link != oldWidget.exercise.link) {
      String? newVideoId = YoutubePlayer.convertUrlToId(widget.exercise.link);
      if (newVideoId != null && controller != null) {
        setState(() {
          controller!.load(newVideoId, startAt: 0);
          // controller!.play();
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        color: Colors.blue[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: YoutubePlayer(
                  controller: controller!,
                  showVideoProgressIndicator: true,
                  onReady: (){
                    controller!.addListener(() {});
                  }
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Proposal is to do this as " + widget.exercise.sequenceOrder.toString()+ " exercise ",
                    // style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.exercise.description.length > 30
                          ? '${widget.exercise.description.substring(0, 30)}...'
                          : widget.exercise.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    secondChild: Text(widget.exercise.description),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => isExpanded = !isExpanded),
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 16),
                    label: Text(isExpanded ? 'Show less' : 'Read more'),
                    style: TextButton.styleFrom(
                      primary: Colors.blue, // Text and icon color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExercisesListWidget extends StatelessWidget {
  final List<Exercise> exercises;

  const ExercisesListWidget({Key? key, required this.exercises})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ExerciseCard(exercise: exercises[index]);
        },
      ),
    );
  }
}
