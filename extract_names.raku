unit sub MAIN($pdf-file where *.IO.f);

my $txt-file = $pdf-file.subst(/\.pdf$/, '.txt');

shell("pdftotext -layout -nopgbrk -eol unix -enc UTF-8 $pdf-file") unless $txt-file.IO.f;

my $all-names = SetHash.new;

for $txt-file.IO.lines.kv -> $i, $line {
    my @matches = $line.comb(/ <:Lu><:L>+ [ ' ' <:Lu><:L>+ ]*/).grep({ !$all-names{$_} }).unique;
    next unless @matches;

    $all-names{$_} = True for @matches;

    say "\e[96m{$i + 1}\e[0m: \e[2m$line\e[0m";
    say @matches.join("\e[2m, \e[0m");
    say "";
}
