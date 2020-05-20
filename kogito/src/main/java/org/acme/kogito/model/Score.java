package org.acme.kogito.model;

public class Score {

    private Double sfw;
    private Double nsfw;
    private String imageId;
    private boolean issfw;

    public Double getSfw() {
        return this.sfw;
    }

    public void setSfw(Double sfw) {
        this.sfw = sfw;
    }

    public Double getNsfw() {
        return this.nsfw;
    }

    public void setNsfw(Double nsfw) {
        this.nsfw = nsfw;
    }

    public String getImageId() {
        return this.imageId;
    }

    public void setImageId(String imageId) {
        this.imageId = imageId;
    }

    public boolean isIssfw() {
        return this.issfw;
    }

    public boolean getIssfw() {
        return this.issfw;
    }

    public void setIssfw(boolean issfw) {
        this.issfw = issfw;
    }

    @Override
    public String toString() {
        return "{" +
            " sfw='" + getSfw() + "'" +
            ", nsfw='" + getNsfw() + "'" +
            ", imageId='" + getImageId() + "'" +
            ", issfw='" + isIssfw() + "'" +
            "}";
    }
 
}