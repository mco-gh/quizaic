// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Generator {
  final String id;
  final String timeCreated;
  final String updated;
  final String selfLink;
  final String name;
  final List<String> answerFormats;
  final List<String> topics;

  const Generator({
    required this.id,
    required this.timeCreated,
    required this.updated,
    required this.selfLink,
    required this.name,
    required this.answerFormats,
    required this.topics,
  });

  factory Generator.fromJson(Map<String, dynamic> json) {
    List<String> answerFormats =
        List<String>.from(json['answerFormats'] as List);
    List<String> topics = List<String>.from(json['topics'] as List);

    return Generator(
      id: json['id'],
      timeCreated: json['timeCreated'],
      updated: json['updated'],
      selfLink: json['selfLink'],
      name: json['name'],
      answerFormats: answerFormats,
      topics: topics,
    );
  }

  Map toJson() => {
        'id': id,
        'timeCreated': timeCreated,
        'updated': updated,
        'selfLink': selfLink,
        'name': name,
        'answerFormats': answerFormats,
        'topics': topics,
      };
}
