class Message {

        private Group messageGroup;
        private Textlabel [] textlabels;

        color bgCol = color(51, 196, 242);
        int m_height, m_width;
        PVector position;
        String m_string;
        String groupName = "messageGroup";
        int m_fontSize = 24;

        public Message(int _w, int _h, PVector _pos, String _s) {
                //bgCol = bgCol;
                m_height = _h;
                m_width = _w;
                position = _pos;
                m_string = _s;
        }

        public Message(int _w, int _h, PVector _pos, String _s, int _fs) {
                m_fontSize = _fs;
                m_height = _h;
                m_width = _w;
                position = _pos;
                m_string = _s;
        }

        public void create() {
                cp5.setAutoDraw(false);

                messageGroup = cp5.addGroup("messageGroup")
                        .setPosition(position)
                                .setSize(m_width, m_height)
                                        .setBackgroundColor(color(bgCol))
                                                .hideBar()
                                                        ;

                textlabels = new Textlabel[1];


                textlabels[0] = cp5.addTextlabel("message")
                        .setText(m_string)
                                .setPosition(10, 10)
                                        .setWidth(m_width - 10)
                                                .setHeight(m_height - 10)
                                                        .setColorValue(0xffffffff)
                                                                .setFont(createFont("Arial", m_fontSize))
                                                                        .setGroup(messageGroup)
                                                                                .setMultiline(true)
                                                                                        ;
        }

        public void create(String gname, String lname) {
                cp5.setAutoDraw(false);
                groupName = gname;

                messageGroup = cp5.addGroup(gname)
                        .setPosition(position)
                                .setSize(m_width, m_height)
                                        .setBackgroundColor(color(bgCol))
                                                .hideBar()
                                                        ;

                textlabels = new Textlabel[1];


                textlabels[0] = cp5.addTextlabel(lname)
                        .setText(m_string)
                                .setPosition(10, 10)
                                        .setWidth(m_width - 10)
                                                .setHeight(m_height - 10)
                                                        .setColorValue(0xffffffff)
                                                                .setFont(createFont("Arial", m_fontSize))
                                                                        .setGroup(messageGroup)
                                                                                .setMultiline(true)
                                                                                        ;
        }

        void drawUI() {
                cp5.draw();
        }

        void destroy() {
                for ( int i = 0 ; i < textlabels.length ; i++ ) {
                        textlabels[i].remove();
                        textlabels[i] = null;
                }
                cp5.getGroup(groupName).remove();
        }

        boolean check() {
                boolean result = false;
                if (textlabels.length > 0) {
                        result = true;
                }
                return result;
        }
}

