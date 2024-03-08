-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_649 is
end project_tb_649;

architecture project_tb_arch_649 of project_tb_649 is
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

constant SCENARIO_LENGTH : integer := 604;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (47,0,190,0,108,0,26,0,31,0,221,0,0,0,0,0,145,0,24,0,232,0,5,0,108,0,224,0,142,0,93,0,192,0,0,0,67,0,0,0,0,0,0,0,169,0,22,0,186,0,27,0,251,0,201,0,0,0,93,0,7,0,0,0,28,0,109,0,246,0,20,0,203,0,92,0,125,0,122,0,94,0,0,0,150,0,0,0,17,0,0,0,0,0,131,0,10,0,32,0,199,0,173,0,154,0,69,0,0,0,0,0,0,0,0,0,0,0,224,0,180,0,57,0,159,0,0,0,241,0,209,0,13,0,0,0,113,0,219,0,39,0,79,0,99,0,232,0,0,0,0,0,0,0,76,0,42,0,220,0,171,0,91,0,79,0,80,0,198,0,146,0,226,0,180,0,85,0,194,0,0,0,167,0,9,0,199,0,16,0,135,0,71,0,40,0,0,0,42,0,200,0,0,0,81,0,0,0,251,0,0,0,221,0,40,0,51,0,231,0,0,0,0,0,188,0,176,0,210,0,121,0,94,0,203,0,62,0,25,0,127,0,19,0,123,0,154,0,17,0,16,0,23,0,21,0,78,0,0,0,0,0,151,0,99,0,205,0,0,0,103,0,180,0,206,0,105,0,242,0,208,0,225,0,77,0,201,0,204,0,79,0,0,0,0,0,206,0,208,0,0,0,0,0,255,0,211,0,64,0,252,0,120,0,31,0,0,0,77,0,0,0,131,0,94,0,253,0,92,0,106,0,86,0,192,0,17,0,0,0,3,0,251,0,29,0,25,0,146,0,104,0,112,0,74,0,0,0,189,0,171,0,0,0,204,0,13,0,45,0,191,0,0,0,95,0,0,0,0,0,0,0,0,0,59,0,224,0,159,0,182,0,229,0,53,0,89,0,138,0,63,0,0,0,127,0,248,0,164,0,0,0,187,0,211,0,33,0,54,0,2,0,12,0,149,0,0,0,234,0,221,0,0,0,34,0,0,0,118,0,27,0,206,0,0,0,0,0,0,0,8,0,243,0,46,0,53,0,190,0,0,0,147,0,232,0,48,0,159,0,127,0,135,0,98,0,192,0,130,0,157,0,103,0,205,0,0,0,0,0,114,0,0,0,174,0,79,0,0,0,228,0,70,0,0,0,0,0,174,0,167,0,136,0,0,0,118,0,175,0,61,0,22,0,0,0,0,0,198,0,185,0,77,0,179,0,176,0,243,0,0,0,231,0,0,0,0,0,194,0,197,0,118,0,0,0,28,0,129,0,218,0,0,0,255,0,214,0,0,0,0,0,69,0,203,0,7,0,62,0,186,0,244,0,98,0,119,0,0,0,0,0,242,0,247,0,127,0,125,0,139,0,197,0,68,0,0,0,97,0,188,0,0,0,200,0,66,0,235,0,0,0,220,0,118,0,212,0,145,0,56,0,251,0,235,0,181,0,218,0,0,0,33,0,85,0,172,0,148,0,250,0,88,0,12,0,193,0,207,0,66,0,255,0,56,0,23,0,109,0,161,0,247,0,5,0,103,0,228,0,0,0,0,0,0,0,214,0,55,0,169,0,51,0,216,0,19,0,68,0,10,0,124,0,47,0,152,0,94,0,249,0,25,0,203,0,14,0,0,0,38,0,215,0,144,0,12,0,109,0,229,0,177,0,107,0,64,0,85,0,43,0,154,0,163,0,35,0,214,0,0,0,14,0,180,0,125,0,1,0,18,0,41,0,225,0,185,0,82,0,0,0,193,0,252,0,86,0,42,0,66,0,0,0,222,0,0,0,98,0,35,0,0,0,45,0,0,0,47,0,0,0,221,0,44,0,0,0,0,0,188,0,183,0,140,0,231,0,0,0,28,0,4,0,175,0,53,0,114,0,0,0,9,0,41,0,161,0,86,0,241,0,167,0,220,0,190,0,224,0,157,0,38,0,241,0,0,0,232,0,38,0,127,0,170,0,97,0,149,0,212,0,210,0,204,0,155,0,38,0,253,0,17,0,83,0,244,0,63,0,223,0,158,0,71,0,246,0,87,0,14,0,152,0,56,0,228,0,106,0,194,0,95,0,95,0,139,0,57,0,0,0,0,0,0,0,19,0,228,0,234,0,0,0,15,0,76,0,206,0,0,0,200,0,135,0,0,0,0,0,169,0,113,0,12,0,244,0,211,0,60,0,121,0,233,0,131,0,218,0,0,0,63,0,127,0,174,0,95,0,53,0,45,0,173,0,156,0,73,0,145,0,137,0,0,0,165,0,202,0,130,0,7,0,224,0,32,0,0,0,245,0,48,0,250,0,104,0,120,0,89,0,125,0,0,0,210,0,34,0,0,0,144,0,15,0,156,0,252,0,177,0,0,0,46,0,81,0,46,0,119,0,0,0,10,0,99,0,140,0,129,0,140,0,16,0,78,0,167,0,0,0,0,0,254,0,220,0,0,0,0,0,15,0,0,0,0,0,156,0,207,0,0,0,228,0,94,0,160,0,255,0,27,0,245,0,156,0,162,0,41,0,147,0,0,0,227,0,1,0,224,0,11,0,129,0,231,0,41,0,165,0,31,0,10,0,96,0,0,0,9,0,229,0,0,0,22,0,40,0,202,0,0,0,0,0,136,0,155,0,28,0,140,0,247,0,0,0,249,0,0,0,0,0,0,0,0,0,212,0,69,0,0,0,126,0,116,0,246,0,137,0,223,0,71,0,0,0,240,0,239,0,39,0,212,0,224,0);
signal scenario_full  : scenario_type := (47,31,190,31,108,31,26,31,31,31,221,31,221,30,221,29,145,31,24,31,232,31,5,31,108,31,224,31,142,31,93,31,192,31,192,30,67,31,67,30,67,29,67,28,169,31,22,31,186,31,27,31,251,31,201,31,201,30,93,31,7,31,7,30,28,31,109,31,246,31,20,31,203,31,92,31,125,31,122,31,94,31,94,30,150,31,150,30,17,31,17,30,17,29,131,31,10,31,32,31,199,31,173,31,154,31,69,31,69,30,69,29,69,28,69,27,69,26,224,31,180,31,57,31,159,31,159,30,241,31,209,31,13,31,13,30,113,31,219,31,39,31,79,31,99,31,232,31,232,30,232,29,232,28,76,31,42,31,220,31,171,31,91,31,79,31,80,31,198,31,146,31,226,31,180,31,85,31,194,31,194,30,167,31,9,31,199,31,16,31,135,31,71,31,40,31,40,30,42,31,200,31,200,30,81,31,81,30,251,31,251,30,221,31,40,31,51,31,231,31,231,30,231,29,188,31,176,31,210,31,121,31,94,31,203,31,62,31,25,31,127,31,19,31,123,31,154,31,17,31,16,31,23,31,21,31,78,31,78,30,78,29,151,31,99,31,205,31,205,30,103,31,180,31,206,31,105,31,242,31,208,31,225,31,77,31,201,31,204,31,79,31,79,30,79,29,206,31,208,31,208,30,208,29,255,31,211,31,64,31,252,31,120,31,31,31,31,30,77,31,77,30,131,31,94,31,253,31,92,31,106,31,86,31,192,31,17,31,17,30,3,31,251,31,29,31,25,31,146,31,104,31,112,31,74,31,74,30,189,31,171,31,171,30,204,31,13,31,45,31,191,31,191,30,95,31,95,30,95,29,95,28,95,27,59,31,224,31,159,31,182,31,229,31,53,31,89,31,138,31,63,31,63,30,127,31,248,31,164,31,164,30,187,31,211,31,33,31,54,31,2,31,12,31,149,31,149,30,234,31,221,31,221,30,34,31,34,30,118,31,27,31,206,31,206,30,206,29,206,28,8,31,243,31,46,31,53,31,190,31,190,30,147,31,232,31,48,31,159,31,127,31,135,31,98,31,192,31,130,31,157,31,103,31,205,31,205,30,205,29,114,31,114,30,174,31,79,31,79,30,228,31,70,31,70,30,70,29,174,31,167,31,136,31,136,30,118,31,175,31,61,31,22,31,22,30,22,29,198,31,185,31,77,31,179,31,176,31,243,31,243,30,231,31,231,30,231,29,194,31,197,31,118,31,118,30,28,31,129,31,218,31,218,30,255,31,214,31,214,30,214,29,69,31,203,31,7,31,62,31,186,31,244,31,98,31,119,31,119,30,119,29,242,31,247,31,127,31,125,31,139,31,197,31,68,31,68,30,97,31,188,31,188,30,200,31,66,31,235,31,235,30,220,31,118,31,212,31,145,31,56,31,251,31,235,31,181,31,218,31,218,30,33,31,85,31,172,31,148,31,250,31,88,31,12,31,193,31,207,31,66,31,255,31,56,31,23,31,109,31,161,31,247,31,5,31,103,31,228,31,228,30,228,29,228,28,214,31,55,31,169,31,51,31,216,31,19,31,68,31,10,31,124,31,47,31,152,31,94,31,249,31,25,31,203,31,14,31,14,30,38,31,215,31,144,31,12,31,109,31,229,31,177,31,107,31,64,31,85,31,43,31,154,31,163,31,35,31,214,31,214,30,14,31,180,31,125,31,1,31,18,31,41,31,225,31,185,31,82,31,82,30,193,31,252,31,86,31,42,31,66,31,66,30,222,31,222,30,98,31,35,31,35,30,45,31,45,30,47,31,47,30,221,31,44,31,44,30,44,29,188,31,183,31,140,31,231,31,231,30,28,31,4,31,175,31,53,31,114,31,114,30,9,31,41,31,161,31,86,31,241,31,167,31,220,31,190,31,224,31,157,31,38,31,241,31,241,30,232,31,38,31,127,31,170,31,97,31,149,31,212,31,210,31,204,31,155,31,38,31,253,31,17,31,83,31,244,31,63,31,223,31,158,31,71,31,246,31,87,31,14,31,152,31,56,31,228,31,106,31,194,31,95,31,95,31,139,31,57,31,57,30,57,29,57,28,19,31,228,31,234,31,234,30,15,31,76,31,206,31,206,30,200,31,135,31,135,30,135,29,169,31,113,31,12,31,244,31,211,31,60,31,121,31,233,31,131,31,218,31,218,30,63,31,127,31,174,31,95,31,53,31,45,31,173,31,156,31,73,31,145,31,137,31,137,30,165,31,202,31,130,31,7,31,224,31,32,31,32,30,245,31,48,31,250,31,104,31,120,31,89,31,125,31,125,30,210,31,34,31,34,30,144,31,15,31,156,31,252,31,177,31,177,30,46,31,81,31,46,31,119,31,119,30,10,31,99,31,140,31,129,31,140,31,16,31,78,31,167,31,167,30,167,29,254,31,220,31,220,30,220,29,15,31,15,30,15,29,156,31,207,31,207,30,228,31,94,31,160,31,255,31,27,31,245,31,156,31,162,31,41,31,147,31,147,30,227,31,1,31,224,31,11,31,129,31,231,31,41,31,165,31,31,31,10,31,96,31,96,30,9,31,229,31,229,30,22,31,40,31,202,31,202,30,202,29,136,31,155,31,28,31,140,31,247,31,247,30,249,31,249,30,249,29,249,28,249,27,212,31,69,31,69,30,126,31,116,31,246,31,137,31,223,31,71,31,71,30,240,31,239,31,39,31,212,31,224,31);

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
