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

constant SCENARIO_LENGTH : integer := 596;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (67,0,149,0,14,0,41,0,92,0,83,0,123,0,53,0,143,0,38,0,102,0,129,0,17,0,0,0,41,0,22,0,222,0,53,0,66,0,143,0,46,0,0,0,19,0,109,0,100,0,0,0,2,0,0,0,5,0,245,0,36,0,162,0,0,0,158,0,129,0,20,0,0,0,88,0,195,0,0,0,108,0,55,0,37,0,74,0,37,0,54,0,135,0,12,0,207,0,0,0,0,0,0,0,193,0,0,0,73,0,112,0,0,0,229,0,0,0,0,0,0,0,79,0,25,0,0,0,159,0,0,0,232,0,0,0,50,0,161,0,92,0,1,0,188,0,203,0,0,0,204,0,19,0,98,0,186,0,0,0,14,0,137,0,0,0,141,0,248,0,178,0,229,0,65,0,0,0,0,0,147,0,203,0,0,0,103,0,75,0,208,0,35,0,174,0,109,0,0,0,65,0,0,0,77,0,0,0,0,0,242,0,0,0,235,0,82,0,28,0,227,0,113,0,0,0,34,0,0,0,0,0,158,0,152,0,47,0,0,0,41,0,55,0,0,0,138,0,93,0,44,0,0,0,0,0,234,0,0,0,170,0,0,0,0,0,112,0,0,0,3,0,135,0,0,0,79,0,0,0,102,0,131,0,59,0,0,0,66,0,95,0,183,0,116,0,55,0,105,0,0,0,83,0,0,0,112,0,171,0,238,0,226,0,199,0,190,0,21,0,116,0,43,0,220,0,28,0,163,0,0,0,229,0,69,0,89,0,246,0,0,0,181,0,222,0,122,0,41,0,226,0,0,0,39,0,97,0,69,0,0,0,37,0,0,0,240,0,140,0,180,0,123,0,76,0,0,0,153,0,91,0,174,0,221,0,0,0,5,0,0,0,206,0,137,0,90,0,42,0,209,0,187,0,211,0,48,0,0,0,193,0,0,0,113,0,149,0,57,0,0,0,39,0,137,0,148,0,0,0,245,0,171,0,210,0,0,0,140,0,103,0,0,0,96,0,110,0,217,0,80,0,180,0,132,0,247,0,165,0,0,0,0,0,133,0,247,0,242,0,246,0,43,0,156,0,94,0,11,0,156,0,126,0,36,0,162,0,150,0,61,0,225,0,175,0,58,0,26,0,81,0,64,0,0,0,216,0,202,0,151,0,195,0,150,0,0,0,145,0,239,0,0,0,0,0,227,0,140,0,52,0,0,0,187,0,0,0,0,0,170,0,0,0,34,0,109,0,214,0,212,0,11,0,64,0,189,0,225,0,59,0,0,0,204,0,176,0,0,0,0,0,0,0,0,0,0,0,133,0,95,0,2,0,215,0,45,0,6,0,0,0,176,0,51,0,124,0,29,0,211,0,165,0,120,0,249,0,145,0,31,0,225,0,57,0,42,0,54,0,127,0,236,0,27,0,43,0,68,0,62,0,252,0,117,0,185,0,187,0,143,0,6,0,72,0,70,0,0,0,0,0,123,0,223,0,0,0,18,0,253,0,28,0,123,0,11,0,0,0,0,0,188,0,232,0,15,0,38,0,230,0,126,0,225,0,2,0,3,0,215,0,0,0,0,0,207,0,29,0,217,0,129,0,0,0,0,0,188,0,48,0,0,0,121,0,171,0,79,0,107,0,113,0,146,0,110,0,25,0,4,0,0,0,214,0,155,0,149,0,114,0,97,0,0,0,6,0,224,0,18,0,0,0,98,0,21,0,216,0,0,0,159,0,0,0,194,0,93,0,0,0,81,0,16,0,70,0,179,0,80,0,0,0,72,0,112,0,36,0,0,0,10,0,78,0,149,0,72,0,0,0,0,0,210,0,0,0,210,0,195,0,0,0,176,0,13,0,122,0,124,0,100,0,0,0,20,0,246,0,51,0,172,0,13,0,197,0,0,0,237,0,168,0,46,0,147,0,7,0,244,0,0,0,251,0,160,0,0,0,177,0,6,0,243,0,65,0,212,0,84,0,166,0,253,0,169,0,152,0,162,0,245,0,111,0,221,0,40,0,203,0,168,0,72,0,0,0,42,0,134,0,249,0,207,0,0,0,17,0,103,0,0,0,0,0,182,0,251,0,173,0,0,0,214,0,17,0,125,0,210,0,0,0,93,0,134,0,169,0,0,0,237,0,182,0,0,0,198,0,60,0,0,0,0,0,88,0,221,0,242,0,72,0,130,0,120,0,20,0,241,0,76,0,108,0,71,0,226,0,97,0,255,0,104,0,152,0,44,0,17,0,123,0,221,0,162,0,81,0,180,0,19,0,98,0,0,0,186,0,0,0,180,0,39,0,69,0,0,0,232,0,0,0,0,0,0,0,172,0,90,0,0,0,227,0,186,0,172,0,77,0,245,0,155,0,54,0,80,0,98,0,56,0,43,0,107,0,0,0,19,0,0,0,82,0,0,0,92,0,63,0,113,0,0,0,16,0,216,0,56,0,0,0,117,0,114,0,176,0,69,0,159,0,180,0,222,0,99,0,48,0,49,0,128,0,191,0,0,0,170,0,196,0,237,0,130,0,227,0,0,0,0,0,45,0,130,0,180,0,25,0,32,0,112,0,152,0,27,0,135,0,135,0,0,0,144,0,207,0,143,0,36,0,0,0,0,0,121,0,3,0,120,0,88,0,0,0,47,0,221,0,111,0,0,0,53,0,168,0,184,0,46,0,226,0,74,0,114,0,84,0);
signal scenario_full  : scenario_type := (67,31,149,31,14,31,41,31,92,31,83,31,123,31,53,31,143,31,38,31,102,31,129,31,17,31,17,30,41,31,22,31,222,31,53,31,66,31,143,31,46,31,46,30,19,31,109,31,100,31,100,30,2,31,2,30,5,31,245,31,36,31,162,31,162,30,158,31,129,31,20,31,20,30,88,31,195,31,195,30,108,31,55,31,37,31,74,31,37,31,54,31,135,31,12,31,207,31,207,30,207,29,207,28,193,31,193,30,73,31,112,31,112,30,229,31,229,30,229,29,229,28,79,31,25,31,25,30,159,31,159,30,232,31,232,30,50,31,161,31,92,31,1,31,188,31,203,31,203,30,204,31,19,31,98,31,186,31,186,30,14,31,137,31,137,30,141,31,248,31,178,31,229,31,65,31,65,30,65,29,147,31,203,31,203,30,103,31,75,31,208,31,35,31,174,31,109,31,109,30,65,31,65,30,77,31,77,30,77,29,242,31,242,30,235,31,82,31,28,31,227,31,113,31,113,30,34,31,34,30,34,29,158,31,152,31,47,31,47,30,41,31,55,31,55,30,138,31,93,31,44,31,44,30,44,29,234,31,234,30,170,31,170,30,170,29,112,31,112,30,3,31,135,31,135,30,79,31,79,30,102,31,131,31,59,31,59,30,66,31,95,31,183,31,116,31,55,31,105,31,105,30,83,31,83,30,112,31,171,31,238,31,226,31,199,31,190,31,21,31,116,31,43,31,220,31,28,31,163,31,163,30,229,31,69,31,89,31,246,31,246,30,181,31,222,31,122,31,41,31,226,31,226,30,39,31,97,31,69,31,69,30,37,31,37,30,240,31,140,31,180,31,123,31,76,31,76,30,153,31,91,31,174,31,221,31,221,30,5,31,5,30,206,31,137,31,90,31,42,31,209,31,187,31,211,31,48,31,48,30,193,31,193,30,113,31,149,31,57,31,57,30,39,31,137,31,148,31,148,30,245,31,171,31,210,31,210,30,140,31,103,31,103,30,96,31,110,31,217,31,80,31,180,31,132,31,247,31,165,31,165,30,165,29,133,31,247,31,242,31,246,31,43,31,156,31,94,31,11,31,156,31,126,31,36,31,162,31,150,31,61,31,225,31,175,31,58,31,26,31,81,31,64,31,64,30,216,31,202,31,151,31,195,31,150,31,150,30,145,31,239,31,239,30,239,29,227,31,140,31,52,31,52,30,187,31,187,30,187,29,170,31,170,30,34,31,109,31,214,31,212,31,11,31,64,31,189,31,225,31,59,31,59,30,204,31,176,31,176,30,176,29,176,28,176,27,176,26,133,31,95,31,2,31,215,31,45,31,6,31,6,30,176,31,51,31,124,31,29,31,211,31,165,31,120,31,249,31,145,31,31,31,225,31,57,31,42,31,54,31,127,31,236,31,27,31,43,31,68,31,62,31,252,31,117,31,185,31,187,31,143,31,6,31,72,31,70,31,70,30,70,29,123,31,223,31,223,30,18,31,253,31,28,31,123,31,11,31,11,30,11,29,188,31,232,31,15,31,38,31,230,31,126,31,225,31,2,31,3,31,215,31,215,30,215,29,207,31,29,31,217,31,129,31,129,30,129,29,188,31,48,31,48,30,121,31,171,31,79,31,107,31,113,31,146,31,110,31,25,31,4,31,4,30,214,31,155,31,149,31,114,31,97,31,97,30,6,31,224,31,18,31,18,30,98,31,21,31,216,31,216,30,159,31,159,30,194,31,93,31,93,30,81,31,16,31,70,31,179,31,80,31,80,30,72,31,112,31,36,31,36,30,10,31,78,31,149,31,72,31,72,30,72,29,210,31,210,30,210,31,195,31,195,30,176,31,13,31,122,31,124,31,100,31,100,30,20,31,246,31,51,31,172,31,13,31,197,31,197,30,237,31,168,31,46,31,147,31,7,31,244,31,244,30,251,31,160,31,160,30,177,31,6,31,243,31,65,31,212,31,84,31,166,31,253,31,169,31,152,31,162,31,245,31,111,31,221,31,40,31,203,31,168,31,72,31,72,30,42,31,134,31,249,31,207,31,207,30,17,31,103,31,103,30,103,29,182,31,251,31,173,31,173,30,214,31,17,31,125,31,210,31,210,30,93,31,134,31,169,31,169,30,237,31,182,31,182,30,198,31,60,31,60,30,60,29,88,31,221,31,242,31,72,31,130,31,120,31,20,31,241,31,76,31,108,31,71,31,226,31,97,31,255,31,104,31,152,31,44,31,17,31,123,31,221,31,162,31,81,31,180,31,19,31,98,31,98,30,186,31,186,30,180,31,39,31,69,31,69,30,232,31,232,30,232,29,232,28,172,31,90,31,90,30,227,31,186,31,172,31,77,31,245,31,155,31,54,31,80,31,98,31,56,31,43,31,107,31,107,30,19,31,19,30,82,31,82,30,92,31,63,31,113,31,113,30,16,31,216,31,56,31,56,30,117,31,114,31,176,31,69,31,159,31,180,31,222,31,99,31,48,31,49,31,128,31,191,31,191,30,170,31,196,31,237,31,130,31,227,31,227,30,227,29,45,31,130,31,180,31,25,31,32,31,112,31,152,31,27,31,135,31,135,31,135,30,144,31,207,31,143,31,36,31,36,30,36,29,121,31,3,31,120,31,88,31,88,30,47,31,221,31,111,31,111,30,53,31,168,31,184,31,46,31,226,31,74,31,114,31,84,31);

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
