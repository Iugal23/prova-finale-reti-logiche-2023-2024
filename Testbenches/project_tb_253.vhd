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

constant SCENARIO_LENGTH : integer := 601;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,240,0,188,0,216,0,240,0,49,0,249,0,29,0,0,0,0,0,64,0,0,0,0,0,246,0,88,0,63,0,106,0,210,0,224,0,194,0,254,0,118,0,125,0,156,0,2,0,0,0,19,0,75,0,0,0,127,0,13,0,129,0,8,0,0,0,98,0,52,0,0,0,152,0,244,0,36,0,0,0,123,0,107,0,0,0,218,0,0,0,15,0,0,0,92,0,36,0,17,0,0,0,239,0,72,0,141,0,86,0,93,0,90,0,93,0,0,0,35,0,253,0,18,0,26,0,229,0,51,0,105,0,94,0,130,0,226,0,11,0,91,0,0,0,0,0,0,0,8,0,38,0,153,0,45,0,223,0,100,0,0,0,213,0,150,0,7,0,251,0,5,0,125,0,196,0,85,0,0,0,62,0,26,0,244,0,245,0,78,0,0,0,15,0,155,0,13,0,105,0,243,0,194,0,118,0,99,0,0,0,195,0,0,0,220,0,0,0,147,0,14,0,167,0,128,0,105,0,0,0,97,0,214,0,191,0,17,0,102,0,35,0,236,0,216,0,174,0,0,0,89,0,197,0,74,0,249,0,151,0,0,0,235,0,17,0,193,0,12,0,245,0,195,0,0,0,148,0,247,0,21,0,93,0,180,0,54,0,47,0,196,0,58,0,111,0,0,0,221,0,110,0,14,0,230,0,219,0,0,0,36,0,19,0,144,0,81,0,0,0,0,0,254,0,29,0,43,0,52,0,21,0,119,0,18,0,45,0,59,0,223,0,0,0,24,0,244,0,32,0,246,0,14,0,224,0,228,0,10,0,92,0,175,0,108,0,228,0,227,0,12,0,168,0,214,0,167,0,213,0,178,0,40,0,92,0,75,0,29,0,111,0,187,0,0,0,0,0,107,0,34,0,118,0,180,0,64,0,0,0,67,0,0,0,206,0,0,0,10,0,166,0,30,0,128,0,232,0,229,0,248,0,83,0,195,0,108,0,32,0,174,0,225,0,0,0,0,0,180,0,0,0,114,0,0,0,132,0,160,0,0,0,234,0,217,0,0,0,30,0,124,0,0,0,0,0,131,0,136,0,117,0,101,0,70,0,0,0,14,0,2,0,0,0,174,0,177,0,167,0,42,0,57,0,199,0,47,0,129,0,0,0,44,0,24,0,243,0,146,0,82,0,137,0,115,0,89,0,33,0,0,0,29,0,80,0,33,0,252,0,225,0,202,0,31,0,65,0,214,0,210,0,82,0,61,0,227,0,245,0,0,0,106,0,132,0,0,0,9,0,193,0,0,0,74,0,174,0,12,0,132,0,245,0,0,0,161,0,159,0,216,0,0,0,222,0,216,0,194,0,0,0,94,0,0,0,18,0,151,0,145,0,220,0,40,0,19,0,13,0,149,0,241,0,248,0,21,0,112,0,0,0,0,0,95,0,0,0,190,0,0,0,181,0,150,0,136,0,94,0,104,0,122,0,0,0,36,0,131,0,196,0,239,0,59,0,237,0,0,0,236,0,138,0,9,0,150,0,0,0,132,0,205,0,146,0,152,0,176,0,153,0,0,0,28,0,0,0,0,0,179,0,51,0,0,0,82,0,50,0,93,0,0,0,38,0,238,0,206,0,183,0,0,0,0,0,186,0,196,0,0,0,0,0,106,0,29,0,25,0,251,0,0,0,43,0,26,0,0,0,0,0,208,0,0,0,0,0,154,0,71,0,0,0,252,0,218,0,13,0,194,0,230,0,199,0,66,0,109,0,0,0,0,0,182,0,0,0,177,0,61,0,0,0,0,0,168,0,174,0,144,0,136,0,47,0,237,0,102,0,159,0,101,0,183,0,0,0,204,0,2,0,226,0,241,0,67,0,0,0,120,0,45,0,190,0,0,0,226,0,138,0,184,0,19,0,122,0,137,0,200,0,174,0,31,0,0,0,165,0,0,0,139,0,30,0,21,0,175,0,4,0,221,0,27,0,160,0,121,0,52,0,81,0,207,0,69,0,149,0,18,0,49,0,0,0,243,0,80,0,62,0,0,0,0,0,6,0,171,0,181,0,115,0,138,0,227,0,150,0,189,0,0,0,23,0,41,0,169,0,220,0,0,0,0,0,0,0,85,0,245,0,155,0,0,0,250,0,164,0,174,0,0,0,109,0,80,0,0,0,241,0,171,0,48,0,76,0,0,0,166,0,208,0,0,0,17,0,87,0,146,0,229,0,106,0,0,0,244,0,194,0,26,0,0,0,204,0,83,0,247,0,129,0,254,0,247,0,255,0,187,0,154,0,71,0,105,0,28,0,81,0,189,0,228,0,204,0,84,0,185,0,118,0,19,0,140,0,0,0,7,0,200,0,0,0,192,0,166,0,17,0,1,0,210,0,0,0,108,0,0,0,0,0,79,0,0,0,248,0,171,0,106,0,199,0,0,0,45,0,112,0,141,0,218,0,0,0,0,0,4,0,101,0,243,0,0,0,8,0,98,0,149,0,202,0,144,0,0,0,0,0,82,0,0,0,0,0,248,0,84,0,197,0,22,0,66,0,246,0,53,0,19,0,73,0,0,0,102,0,0,0,222,0,113,0,124,0,60,0,59,0,181,0,0,0,192,0,216,0,0,0,0,0,105,0,140,0,50,0,130,0,249,0,0,0,241,0,234,0,55,0,113,0,0,0,0,0,195,0,39,0,0,0,240,0,220,0,62,0);
signal scenario_full  : scenario_type := (0,0,240,31,188,31,216,31,240,31,49,31,249,31,29,31,29,30,29,29,64,31,64,30,64,29,246,31,88,31,63,31,106,31,210,31,224,31,194,31,254,31,118,31,125,31,156,31,2,31,2,30,19,31,75,31,75,30,127,31,13,31,129,31,8,31,8,30,98,31,52,31,52,30,152,31,244,31,36,31,36,30,123,31,107,31,107,30,218,31,218,30,15,31,15,30,92,31,36,31,17,31,17,30,239,31,72,31,141,31,86,31,93,31,90,31,93,31,93,30,35,31,253,31,18,31,26,31,229,31,51,31,105,31,94,31,130,31,226,31,11,31,91,31,91,30,91,29,91,28,8,31,38,31,153,31,45,31,223,31,100,31,100,30,213,31,150,31,7,31,251,31,5,31,125,31,196,31,85,31,85,30,62,31,26,31,244,31,245,31,78,31,78,30,15,31,155,31,13,31,105,31,243,31,194,31,118,31,99,31,99,30,195,31,195,30,220,31,220,30,147,31,14,31,167,31,128,31,105,31,105,30,97,31,214,31,191,31,17,31,102,31,35,31,236,31,216,31,174,31,174,30,89,31,197,31,74,31,249,31,151,31,151,30,235,31,17,31,193,31,12,31,245,31,195,31,195,30,148,31,247,31,21,31,93,31,180,31,54,31,47,31,196,31,58,31,111,31,111,30,221,31,110,31,14,31,230,31,219,31,219,30,36,31,19,31,144,31,81,31,81,30,81,29,254,31,29,31,43,31,52,31,21,31,119,31,18,31,45,31,59,31,223,31,223,30,24,31,244,31,32,31,246,31,14,31,224,31,228,31,10,31,92,31,175,31,108,31,228,31,227,31,12,31,168,31,214,31,167,31,213,31,178,31,40,31,92,31,75,31,29,31,111,31,187,31,187,30,187,29,107,31,34,31,118,31,180,31,64,31,64,30,67,31,67,30,206,31,206,30,10,31,166,31,30,31,128,31,232,31,229,31,248,31,83,31,195,31,108,31,32,31,174,31,225,31,225,30,225,29,180,31,180,30,114,31,114,30,132,31,160,31,160,30,234,31,217,31,217,30,30,31,124,31,124,30,124,29,131,31,136,31,117,31,101,31,70,31,70,30,14,31,2,31,2,30,174,31,177,31,167,31,42,31,57,31,199,31,47,31,129,31,129,30,44,31,24,31,243,31,146,31,82,31,137,31,115,31,89,31,33,31,33,30,29,31,80,31,33,31,252,31,225,31,202,31,31,31,65,31,214,31,210,31,82,31,61,31,227,31,245,31,245,30,106,31,132,31,132,30,9,31,193,31,193,30,74,31,174,31,12,31,132,31,245,31,245,30,161,31,159,31,216,31,216,30,222,31,216,31,194,31,194,30,94,31,94,30,18,31,151,31,145,31,220,31,40,31,19,31,13,31,149,31,241,31,248,31,21,31,112,31,112,30,112,29,95,31,95,30,190,31,190,30,181,31,150,31,136,31,94,31,104,31,122,31,122,30,36,31,131,31,196,31,239,31,59,31,237,31,237,30,236,31,138,31,9,31,150,31,150,30,132,31,205,31,146,31,152,31,176,31,153,31,153,30,28,31,28,30,28,29,179,31,51,31,51,30,82,31,50,31,93,31,93,30,38,31,238,31,206,31,183,31,183,30,183,29,186,31,196,31,196,30,196,29,106,31,29,31,25,31,251,31,251,30,43,31,26,31,26,30,26,29,208,31,208,30,208,29,154,31,71,31,71,30,252,31,218,31,13,31,194,31,230,31,199,31,66,31,109,31,109,30,109,29,182,31,182,30,177,31,61,31,61,30,61,29,168,31,174,31,144,31,136,31,47,31,237,31,102,31,159,31,101,31,183,31,183,30,204,31,2,31,226,31,241,31,67,31,67,30,120,31,45,31,190,31,190,30,226,31,138,31,184,31,19,31,122,31,137,31,200,31,174,31,31,31,31,30,165,31,165,30,139,31,30,31,21,31,175,31,4,31,221,31,27,31,160,31,121,31,52,31,81,31,207,31,69,31,149,31,18,31,49,31,49,30,243,31,80,31,62,31,62,30,62,29,6,31,171,31,181,31,115,31,138,31,227,31,150,31,189,31,189,30,23,31,41,31,169,31,220,31,220,30,220,29,220,28,85,31,245,31,155,31,155,30,250,31,164,31,174,31,174,30,109,31,80,31,80,30,241,31,171,31,48,31,76,31,76,30,166,31,208,31,208,30,17,31,87,31,146,31,229,31,106,31,106,30,244,31,194,31,26,31,26,30,204,31,83,31,247,31,129,31,254,31,247,31,255,31,187,31,154,31,71,31,105,31,28,31,81,31,189,31,228,31,204,31,84,31,185,31,118,31,19,31,140,31,140,30,7,31,200,31,200,30,192,31,166,31,17,31,1,31,210,31,210,30,108,31,108,30,108,29,79,31,79,30,248,31,171,31,106,31,199,31,199,30,45,31,112,31,141,31,218,31,218,30,218,29,4,31,101,31,243,31,243,30,8,31,98,31,149,31,202,31,144,31,144,30,144,29,82,31,82,30,82,29,248,31,84,31,197,31,22,31,66,31,246,31,53,31,19,31,73,31,73,30,102,31,102,30,222,31,113,31,124,31,60,31,59,31,181,31,181,30,192,31,216,31,216,30,216,29,105,31,140,31,50,31,130,31,249,31,249,30,241,31,234,31,55,31,113,31,113,30,113,29,195,31,39,31,39,30,240,31,220,31,62,31);

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
