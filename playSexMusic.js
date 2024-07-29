
var allMusicNames = ['1979 抉擇 .mp3', 'GreenLeaves.mp3', '每當變幻時.mp3', 'ideas.mp3', 'lowBeep.mp3', 'pig.mp3', 'Spirit of Harp.mp3', 'Stepping into the Ether.mp3', 'stringVibrate.mp3', 'The Sound of Silence.mp3', 'toneBeep.mp3', '吟盡楚江秋.mp3', '一生所爱.mp3', '一眼忧伤.mp3', '不了情.mp3', '世界由我造.mp3', '之子于歸.mp3', '倩女幽魂.mp3', '兩忘煙水裡.mp3', '兩生契.mp3', '大丈夫.mp3', '大內群英.mp3', '大刀王五.mp3', '天蠶變 .mp3', '太極張三豐.mp3', '子衿.mp3', '小刀会.mp3', '小提琴 陈情令 无羁.mp3', '少女慈禧.mp3', '幽狐.mp3', '徐小鳳 人似浪花.mp3', '我住長江頭.mp3', '擊鼓.mp3', '春雨彎刀.mp3', '曾路得 天各一方.mp3', '梁凱莉《癡雲》.mp3', '楚国八百年.mp3', '楚國情歌.mp3', '此生长.mp3', '殇 大提琴版.mp3', '江南春色.mp3', '沧海一声笑.mp3', '清溪潺流.mp3', '王琪.mp3', '琵琶吟.mp3', '琵琶语.mp3', '石莉娟 二泉映月.mp3', '秋戀.mp3', '程桂蘭  二泉映月.mp3', '翡翠劇場 - 風雲.mp3', '大俠霍元甲.mp3', '葉振棠.mp3', '蒹葭.mp3', '倩影.mp3', '誰能明白我.mp3', '跳灰.mp3', '追憶.mp3', '醉梦 陈悦.mp3', '關正傑 - 天蠶變.mp3', '陶笛 森林狂想曲.mp3', '雨碎江南.mp3', '齊豫 - 橄欖樹.mp3']
var options = '';  // build the List select option

for (var i = 0; i < allMusicNames.length; i++) {
         options += '<option value="' + allMusicNames[i]+ '">' + allMusicNames[i] + '</option>';
}
$("#selectList").html(options);

function changeAudioSource(source) {
  selectElement = document.getElementById('selectList');
  selectedOption = selectElement.value;
  selectedOption = "D:/Dropbox/Public/LibDocs/mp3/" + selectedOption
  console.log('Selected option: ' + selectedOption);

  soundID = document.getElementById('myaudio');
  soundID.src = selectedOption;
  soundID.load();
  soundID.play();
  soundID.volume = 0.05;
}

