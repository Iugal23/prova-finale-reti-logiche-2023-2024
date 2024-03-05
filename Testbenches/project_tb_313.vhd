-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 683;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (53,0,62,0,96,0,79,0,148,0,0,0,50,0,78,0,188,0,104,0,162,0,85,0,80,0,41,0,72,0,25,0,69,0,219,0,231,0,68,0,0,0,181,0,208,0,100,0,79,0,0,0,151,0,37,0,199,0,66,0,105,0,0,0,149,0,26,0,0,0,105,0,31,0,255,0,55,0,0,0,0,0,31,0,169,0,0,0,199,0,225,0,0,0,0,0,144,0,140,0,71,0,195,0,233,0,135,0,40,0,186,0,0,0,109,0,0,0,228,0,244,0,246,0,120,0,42,0,250,0,118,0,105,0,162,0,0,0,0,0,41,0,138,0,63,0,202,0,209,0,0,0,0,0,150,0,0,0,155,0,109,0,0,0,20,0,0,0,192,0,242,0,222,0,54,0,117,0,122,0,0,0,0,0,178,0,222,0,0,0,0,0,204,0,81,0,39,0,201,0,145,0,46,0,20,0,16,0,0,0,194,0,53,0,0,0,92,0,140,0,39,0,0,0,13,0,12,0,235,0,129,0,0,0,203,0,89,0,122,0,47,0,220,0,9,0,91,0,137,0,219,0,164,0,0,0,125,0,131,0,44,0,218,0,0,0,115,0,115,0,114,0,243,0,0,0,76,0,48,0,0,0,141,0,0,0,4,0,19,0,28,0,151,0,0,0,132,0,141,0,153,0,0,0,0,0,69,0,235,0,171,0,217,0,98,0,134,0,215,0,0,0,151,0,109,0,0,0,252,0,165,0,106,0,146,0,124,0,139,0,58,0,0,0,0,0,0,0,0,0,0,0,29,0,102,0,168,0,164,0,153,0,40,0,0,0,0,0,251,0,17,0,27,0,136,0,94,0,166,0,122,0,187,0,223,0,59,0,32,0,88,0,231,0,225,0,229,0,85,0,0,0,142,0,191,0,157,0,0,0,30,0,30,0,69,0,246,0,0,0,102,0,200,0,130,0,0,0,12,0,121,0,117,0,59,0,247,0,64,0,62,0,0,0,0,0,204,0,121,0,116,0,23,0,250,0,0,0,56,0,155,0,141,0,81,0,194,0,0,0,0,0,231,0,43,0,31,0,87,0,52,0,0,0,143,0,0,0,197,0,220,0,193,0,45,0,189,0,57,0,219,0,14,0,208,0,83,0,168,0,244,0,0,0,150,0,134,0,0,0,150,0,216,0,70,0,0,0,0,0,72,0,206,0,122,0,115,0,224,0,131,0,60,0,0,0,71,0,63,0,0,0,0,0,74,0,65,0,228,0,181,0,25,0,35,0,56,0,0,0,183,0,94,0,38,0,184,0,44,0,159,0,253,0,93,0,131,0,0,0,199,0,93,0,40,0,0,0,159,0,0,0,56,0,69,0,134,0,0,0,0,0,175,0,0,0,5,0,0,0,198,0,124,0,213,0,6,0,0,0,196,0,126,0,204,0,0,0,255,0,0,0,46,0,162,0,0,0,32,0,0,0,196,0,0,0,55,0,204,0,0,0,136,0,248,0,167,0,104,0,0,0,67,0,110,0,23,0,151,0,215,0,193,0,156,0,0,0,76,0,115,0,74,0,212,0,0,0,253,0,230,0,0,0,55,0,7,0,139,0,200,0,8,0,0,0,0,0,0,0,190,0,71,0,155,0,225,0,247,0,0,0,189,0,68,0,0,0,22,0,164,0,0,0,196,0,20,0,134,0,9,0,48,0,71,0,0,0,103,0,0,0,43,0,249,0,131,0,247,0,75,0,137,0,246,0,21,0,160,0,117,0,65,0,158,0,0,0,7,0,249,0,1,0,0,0,159,0,218,0,9,0,117,0,89,0,104,0,162,0,60,0,0,0,123,0,165,0,199,0,39,0,183,0,0,0,87,0,224,0,136,0,73,0,0,0,158,0,0,0,205,0,0,0,49,0,166,0,0,0,246,0,96,0,0,0,197,0,236,0,170,0,0,0,80,0,103,0,53,0,133,0,134,0,167,0,0,0,18,0,255,0,113,0,0,0,185,0,217,0,129,0,202,0,0,0,150,0,93,0,4,0,204,0,172,0,0,0,0,0,138,0,23,0,255,0,147,0,0,0,0,0,138,0,141,0,222,0,30,0,6,0,0,0,133,0,0,0,166,0,46,0,100,0,99,0,253,0,150,0,6,0,0,0,245,0,71,0,205,0,109,0,72,0,236,0,19,0,0,0,247,0,0,0,0,0,245,0,189,0,0,0,46,0,240,0,78,0,129,0,211,0,87,0,214,0,124,0,103,0,0,0,33,0,218,0,240,0,0,0,0,0,199,0,0,0,91,0,79,0,175,0,194,0,37,0,174,0,0,0,41,0,6,0,56,0,189,0,14,0,26,0,89,0,191,0,197,0,48,0,172,0,0,0,166,0,130,0,53,0,78,0,181,0,90,0,232,0,13,0,148,0,133,0,227,0,94,0,243,0,205,0,20,0,0,0,249,0,0,0,66,0,0,0,86,0,174,0,52,0,0,0,181,0,175,0,84,0,88,0,155,0,130,0,120,0,0,0,16,0,0,0,82,0,17,0,0,0,7,0,0,0,61,0,0,0,173,0,144,0,28,0,16,0,0,0,156,0,0,0,0,0,0,0,98,0,242,0,0,0,227,0,77,0,236,0,185,0,0,0,14,0,0,0,165,0,0,0,214,0,23,0,168,0,0,0,96,0,116,0,83,0,97,0,247,0,72,0,196,0,0,0,236,0,0,0,249,0,70,0,0,0,250,0,161,0,126,0,252,0,183,0,17,0,156,0,245,0,0,0,6,0,0,0,186,0,158,0,144,0,236,0,165,0,1,0,18,0,117,0,225,0,222,0,5,0,156,0,44,0,247,0,0,0,0,0,76,0,250,0,0,0,0,0,74,0,0,0,203,0,184,0,241,0,139,0,0,0,0,0,2,0,101,0,130,0,0,0,13,0,187,0,170,0,31,0,74,0,180,0,140,0,115,0,84,0,0,0,216,0,0,0,74,0,139,0,213,0,249,0,16,0,152,0,59,0,234,0,62,0,160,0,0,0,78,0,234,0,7,0,235,0,65,0,0,0,76,0,115,0,240,0,24,0,0,0);
signal scenario_full  : scenario_type := (53,31,62,31,96,31,79,31,148,31,148,30,50,31,78,31,188,31,104,31,162,31,85,31,80,31,41,31,72,31,25,31,69,31,219,31,231,31,68,31,68,30,181,31,208,31,100,31,79,31,79,30,151,31,37,31,199,31,66,31,105,31,105,30,149,31,26,31,26,30,105,31,31,31,255,31,55,31,55,30,55,29,31,31,169,31,169,30,199,31,225,31,225,30,225,29,144,31,140,31,71,31,195,31,233,31,135,31,40,31,186,31,186,30,109,31,109,30,228,31,244,31,246,31,120,31,42,31,250,31,118,31,105,31,162,31,162,30,162,29,41,31,138,31,63,31,202,31,209,31,209,30,209,29,150,31,150,30,155,31,109,31,109,30,20,31,20,30,192,31,242,31,222,31,54,31,117,31,122,31,122,30,122,29,178,31,222,31,222,30,222,29,204,31,81,31,39,31,201,31,145,31,46,31,20,31,16,31,16,30,194,31,53,31,53,30,92,31,140,31,39,31,39,30,13,31,12,31,235,31,129,31,129,30,203,31,89,31,122,31,47,31,220,31,9,31,91,31,137,31,219,31,164,31,164,30,125,31,131,31,44,31,218,31,218,30,115,31,115,31,114,31,243,31,243,30,76,31,48,31,48,30,141,31,141,30,4,31,19,31,28,31,151,31,151,30,132,31,141,31,153,31,153,30,153,29,69,31,235,31,171,31,217,31,98,31,134,31,215,31,215,30,151,31,109,31,109,30,252,31,165,31,106,31,146,31,124,31,139,31,58,31,58,30,58,29,58,28,58,27,58,26,29,31,102,31,168,31,164,31,153,31,40,31,40,30,40,29,251,31,17,31,27,31,136,31,94,31,166,31,122,31,187,31,223,31,59,31,32,31,88,31,231,31,225,31,229,31,85,31,85,30,142,31,191,31,157,31,157,30,30,31,30,31,69,31,246,31,246,30,102,31,200,31,130,31,130,30,12,31,121,31,117,31,59,31,247,31,64,31,62,31,62,30,62,29,204,31,121,31,116,31,23,31,250,31,250,30,56,31,155,31,141,31,81,31,194,31,194,30,194,29,231,31,43,31,31,31,87,31,52,31,52,30,143,31,143,30,197,31,220,31,193,31,45,31,189,31,57,31,219,31,14,31,208,31,83,31,168,31,244,31,244,30,150,31,134,31,134,30,150,31,216,31,70,31,70,30,70,29,72,31,206,31,122,31,115,31,224,31,131,31,60,31,60,30,71,31,63,31,63,30,63,29,74,31,65,31,228,31,181,31,25,31,35,31,56,31,56,30,183,31,94,31,38,31,184,31,44,31,159,31,253,31,93,31,131,31,131,30,199,31,93,31,40,31,40,30,159,31,159,30,56,31,69,31,134,31,134,30,134,29,175,31,175,30,5,31,5,30,198,31,124,31,213,31,6,31,6,30,196,31,126,31,204,31,204,30,255,31,255,30,46,31,162,31,162,30,32,31,32,30,196,31,196,30,55,31,204,31,204,30,136,31,248,31,167,31,104,31,104,30,67,31,110,31,23,31,151,31,215,31,193,31,156,31,156,30,76,31,115,31,74,31,212,31,212,30,253,31,230,31,230,30,55,31,7,31,139,31,200,31,8,31,8,30,8,29,8,28,190,31,71,31,155,31,225,31,247,31,247,30,189,31,68,31,68,30,22,31,164,31,164,30,196,31,20,31,134,31,9,31,48,31,71,31,71,30,103,31,103,30,43,31,249,31,131,31,247,31,75,31,137,31,246,31,21,31,160,31,117,31,65,31,158,31,158,30,7,31,249,31,1,31,1,30,159,31,218,31,9,31,117,31,89,31,104,31,162,31,60,31,60,30,123,31,165,31,199,31,39,31,183,31,183,30,87,31,224,31,136,31,73,31,73,30,158,31,158,30,205,31,205,30,49,31,166,31,166,30,246,31,96,31,96,30,197,31,236,31,170,31,170,30,80,31,103,31,53,31,133,31,134,31,167,31,167,30,18,31,255,31,113,31,113,30,185,31,217,31,129,31,202,31,202,30,150,31,93,31,4,31,204,31,172,31,172,30,172,29,138,31,23,31,255,31,147,31,147,30,147,29,138,31,141,31,222,31,30,31,6,31,6,30,133,31,133,30,166,31,46,31,100,31,99,31,253,31,150,31,6,31,6,30,245,31,71,31,205,31,109,31,72,31,236,31,19,31,19,30,247,31,247,30,247,29,245,31,189,31,189,30,46,31,240,31,78,31,129,31,211,31,87,31,214,31,124,31,103,31,103,30,33,31,218,31,240,31,240,30,240,29,199,31,199,30,91,31,79,31,175,31,194,31,37,31,174,31,174,30,41,31,6,31,56,31,189,31,14,31,26,31,89,31,191,31,197,31,48,31,172,31,172,30,166,31,130,31,53,31,78,31,181,31,90,31,232,31,13,31,148,31,133,31,227,31,94,31,243,31,205,31,20,31,20,30,249,31,249,30,66,31,66,30,86,31,174,31,52,31,52,30,181,31,175,31,84,31,88,31,155,31,130,31,120,31,120,30,16,31,16,30,82,31,17,31,17,30,7,31,7,30,61,31,61,30,173,31,144,31,28,31,16,31,16,30,156,31,156,30,156,29,156,28,98,31,242,31,242,30,227,31,77,31,236,31,185,31,185,30,14,31,14,30,165,31,165,30,214,31,23,31,168,31,168,30,96,31,116,31,83,31,97,31,247,31,72,31,196,31,196,30,236,31,236,30,249,31,70,31,70,30,250,31,161,31,126,31,252,31,183,31,17,31,156,31,245,31,245,30,6,31,6,30,186,31,158,31,144,31,236,31,165,31,1,31,18,31,117,31,225,31,222,31,5,31,156,31,44,31,247,31,247,30,247,29,76,31,250,31,250,30,250,29,74,31,74,30,203,31,184,31,241,31,139,31,139,30,139,29,2,31,101,31,130,31,130,30,13,31,187,31,170,31,31,31,74,31,180,31,140,31,115,31,84,31,84,30,216,31,216,30,74,31,139,31,213,31,249,31,16,31,152,31,59,31,234,31,62,31,160,31,160,30,78,31,234,31,7,31,235,31,65,31,65,30,76,31,115,31,240,31,24,31,24,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
