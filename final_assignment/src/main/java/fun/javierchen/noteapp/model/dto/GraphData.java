package fun.javierchen.noteapp.model.dto;

import java.util.List;

public class GraphData {

    private List<GraphNode> nodes;
    private List<GraphEdge> edges;

    public GraphData() {
    }

    public List<GraphNode> getNodes() {
        return nodes;
    }

    public void setNodes(List<GraphNode> nodes) {
        this.nodes = nodes;
    }

    public List<GraphEdge> getEdges() {
        return edges;
    }

    public void setEdges(List<GraphEdge> edges) {
        this.edges = edges;
    }

    @Override
    public String toString() {
        return "GraphData{" +
                "nodes=" + nodes +
                ", edges=" + edges +
                '}';
    }

    public static class GraphNode {

        private Long id;
        private String title;
        private int links;
        private String tag;

        public GraphNode() {
        }

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public int getLinks() {
            return links;
        }

        public void setLinks(int links) {
            this.links = links;
        }

        public String getTag() {
            return tag;
        }

        public void setTag(String tag) {
            this.tag = tag;
        }

        @Override
        public String toString() {
            return "GraphNode{" +
                    "id=" + id +
                    ", title='" + title + '\'' +
                    ", links=" + links +
                    ", tag='" + tag + '\'' +
                    '}';
        }
    }

    public static class GraphEdge {

        private Long source;
        private Long target;

        public GraphEdge() {
        }

        public Long getSource() {
            return source;
        }

        public void setSource(Long source) {
            this.source = source;
        }

        public Long getTarget() {
            return target;
        }

        public void setTarget(Long target) {
            this.target = target;
        }

        @Override
        public String toString() {
            return "GraphEdge{" +
                    "source=" + source +
                    ", target=" + target +
                    '}';
        }
    }
}
