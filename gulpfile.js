var gulp   = require('gulp')
var coffee = require('gulp-coffee')
var rename = require('gulp-rename')
var uglify = require('gulp-uglify')

gulp.task('build', function() {
  gulp.src('src/jquery.expandableRow.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('lib'));
});

gulp.task('uglify', function() {
  gulp.src('lib/jquery.expandableRow.js')
    .pipe(uglify())
    .pipe(rename('jquery.expandableRow.min.js'))
    .pipe(gulp.dest('lib'));
});
