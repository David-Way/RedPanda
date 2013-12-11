class Exercise {

        private int exercise_id = -1;
        private String name = "default name";
        private String description = "default description";
        private int level = -1;
        private int repetitions = -1;

        public Exercise (int e_id, String n, String d, int l, int r) {
                this.exercise_id = e_id;
                this.name = n;
                this.description = d;
                this.level = l;
                this.repetitions = r;
        }

        public int getExercise_id() {
                return exercise_id;
        }

        public void setExercise_id(int exercise_id) {
                this.exercise_id = exercise_id;
        }

        public String getName() {
                return name;
        }

        public void setName(String name) {
                this.name = name;
        }

        public String getDescription() {
                return description;
        }

        public void setDescription(String description) {
                this.description = description;
        }

        public int getLevel() {
                return level;
        }

        public void setLevel(int level) {
                this.level = level;
        }

        public int getRepetitions() {
                return repetitions;
        }

        public void setRepetitions(int repetitions) {
                this.repetitions = repetitions;
        }
}

