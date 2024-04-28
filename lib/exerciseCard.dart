import 'package:fitnessapp/model/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'model/ExerciseGroup.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final bool isAdmin;
  final Function(String) onDelete;
  final Function(Exercise) onEdit;
  final List<ExerciseGroup> exerciseGroups;

  const ExerciseCard({Key? key, required this.exercise, this.isAdmin = false, required this.onDelete, required this.onEdit, required this.exerciseGroups}) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isExpanded = false;
  YoutubePlayerController? controller;

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this exercise?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(widget.exercise.id);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final editedExercise = widget.exercise.copy();
        String? selectedGroup = editedExercise.exerciseGroup;
        return AlertDialog(
          title: const Text('Edit Exercise'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  initialValue: widget.exercise.name,
                  onChanged: (value) => editedExercise.name = value,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  initialValue: editedExercise.description,
                  onChanged: (value) => editedExercise.description = value,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  initialValue: editedExercise.sequenceOrder.toString(),
                  onChanged: (value) => editedExercise.sequenceOrder = int.tryParse(value) ?? 0,
                  decoration: InputDecoration(labelText: 'Sequence Order'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  initialValue: editedExercise.link,
                  onChanged: (value) => editedExercise.link = value,
                  decoration: InputDecoration(labelText: 'Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Edit'),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                editedExercise.exerciseGroup = selectedGroup ?? editedExercise.exerciseGroup;
                Navigator.of(context).pop();
                widget.onEdit(editedExercise);
              },
            ),
          ],
        );
      },
    );
  }

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
        flags: const YoutubePlayerFlags(
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
                    "Proposal is to do this as " + widget.exercise.sequenceOrder.toString()+ ". exercise ",
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
                  if (widget.isAdmin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: _showEditDialog,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: _showDeleteConfirmationDialog,
                        ),
                      ],
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
  final bool isAdmin;
  final Function(String) onDelete;
  final Function(Exercise) onEdit;
  final List<ExerciseGroup> exerciseGroups;

  const ExercisesListWidget({Key? key, required this.exercises,  this.isAdmin = false, required this.onDelete, required this.onEdit, required this.exerciseGroups})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 435,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ExerciseCard(exercise: exercises[index], isAdmin: isAdmin, onDelete: onDelete, onEdit: onEdit, exerciseGroups: exerciseGroups);
        },
      ),
    );
  }
}
