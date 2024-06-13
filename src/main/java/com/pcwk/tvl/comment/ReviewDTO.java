package com.pcwk.ehr.travel;

public class ReviewDTO {
    private int seq;
    private String boardSeq;
    private String contents;
    private String imgLink;
    private String regId;
    private String regDt;
    private String modId;
    private String modDt;

    // Getters and Setters
    public int getSeq() {
        return seq;
    }
    public void setSeq(int seq) {
        this.seq = seq;
    }
    public String getBoardSeq() {
        return boardSeq;
    }
    public void setBoardSeq(String boardSeq) {
        this.boardSeq = boardSeq;
    }
    public String getContents() {
        return contents;
    }
    public void setContents(String contents) {
        this.contents = contents;
    }
    public String getImgLink() {
        return imgLink;
    }
    public void setImgLink(String imgLink) {
        this.imgLink = imgLink;
    }
    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
    public String getRegDt() {
        return regDt;
    }
    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }
    public String getModId() {
        return modId;
    }
    public void setModId(String modId) {
        this.modId = modId;
    }
    public String getModDt() {
        return modDt;
    }
    public void setModDt(String modDt) {
        this.modDt = modDt;
    }
}
