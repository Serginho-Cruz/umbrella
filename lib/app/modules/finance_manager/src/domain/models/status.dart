enum Status { okay, inTime, overdue }

extension StatusName on Status {
  String get adaptedName => switch (this) {
        Status.okay => 'Paga',
        Status.inTime => 'Em Tempo',
        Status.overdue => 'Vencida',
      };
}
