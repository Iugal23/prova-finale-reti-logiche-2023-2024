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

constant SCENARIO_LENGTH : integer := 593;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,2,0,188,0,0,0,145,0,108,0,150,0,177,0,194,0,0,0,100,0,139,0,4,0,250,0,0,0,110,0,0,0,121,0,79,0,0,0,12,0,134,0,198,0,87,0,0,0,0,0,152,0,0,0,168,0,71,0,241,0,112,0,31,0,113,0,54,0,6,0,121,0,14,0,0,0,234,0,210,0,92,0,0,0,254,0,168,0,47,0,218,0,197,0,53,0,0,0,0,0,184,0,202,0,144,0,65,0,255,0,214,0,148,0,183,0,164,0,191,0,249,0,101,0,197,0,90,0,218,0,237,0,218,0,0,0,0,0,218,0,218,0,51,0,193,0,255,0,14,0,168,0,60,0,66,0,161,0,127,0,234,0,45,0,51,0,0,0,103,0,231,0,141,0,160,0,0,0,40,0,252,0,0,0,0,0,33,0,36,0,91,0,25,0,81,0,34,0,49,0,217,0,0,0,221,0,95,0,86,0,0,0,104,0,214,0,206,0,207,0,211,0,190,0,99,0,0,0,170,0,100,0,183,0,167,0,201,0,0,0,227,0,109,0,13,0,65,0,89,0,112,0,8,0,249,0,61,0,44,0,0,0,132,0,242,0,180,0,142,0,52,0,184,0,87,0,231,0,0,0,72,0,106,0,140,0,62,0,0,0,0,0,88,0,32,0,0,0,247,0,164,0,248,0,9,0,0,0,14,0,123,0,0,0,180,0,173,0,250,0,0,0,83,0,0,0,72,0,0,0,162,0,0,0,62,0,0,0,195,0,61,0,141,0,0,0,99,0,0,0,237,0,222,0,132,0,47,0,57,0,83,0,229,0,0,0,159,0,103,0,163,0,108,0,225,0,47,0,48,0,249,0,1,0,36,0,123,0,59,0,80,0,58,0,44,0,197,0,26,0,77,0,103,0,0,0,33,0,0,0,162,0,27,0,108,0,31,0,0,0,132,0,0,0,0,0,0,0,176,0,163,0,71,0,165,0,68,0,186,0,50,0,34,0,142,0,69,0,0,0,89,0,188,0,144,0,39,0,0,0,212,0,174,0,187,0,179,0,220,0,0,0,120,0,200,0,8,0,231,0,135,0,209,0,141,0,191,0,164,0,129,0,47,0,207,0,196,0,32,0,54,0,170,0,214,0,0,0,140,0,21,0,0,0,33,0,255,0,0,0,156,0,163,0,26,0,132,0,231,0,0,0,244,0,75,0,0,0,131,0,57,0,13,0,36,0,0,0,63,0,227,0,0,0,213,0,80,0,0,0,84,0,0,0,75,0,23,0,64,0,192,0,103,0,191,0,248,0,0,0,200,0,33,0,0,0,14,0,133,0,9,0,209,0,0,0,139,0,158,0,93,0,0,0,120,0,154,0,214,0,143,0,142,0,142,0,194,0,240,0,35,0,0,0,239,0,89,0,240,0,96,0,22,0,184,0,0,0,105,0,0,0,143,0,141,0,96,0,140,0,46,0,8,0,35,0,216,0,210,0,137,0,118,0,220,0,53,0,175,0,255,0,93,0,241,0,0,0,241,0,172,0,35,0,0,0,56,0,254,0,13,0,73,0,42,0,229,0,106,0,242,0,183,0,0,0,22,0,200,0,23,0,92,0,0,0,212,0,243,0,37,0,214,0,233,0,30,0,101,0,0,0,0,0,18,0,161,0,112,0,205,0,35,0,102,0,31,0,158,0,0,0,230,0,87,0,229,0,99,0,198,0,252,0,7,0,216,0,57,0,55,0,69,0,130,0,129,0,203,0,50,0,6,0,224,0,8,0,158,0,0,0,103,0,0,0,0,0,224,0,155,0,199,0,153,0,118,0,197,0,195,0,83,0,154,0,200,0,0,0,42,0,0,0,0,0,24,0,249,0,0,0,96,0,0,0,0,0,121,0,179,0,27,0,209,0,23,0,154,0,30,0,125,0,0,0,124,0,78,0,0,0,177,0,32,0,62,0,137,0,0,0,34,0,72,0,176,0,0,0,154,0,183,0,152,0,196,0,40,0,10,0,202,0,205,0,219,0,45,0,93,0,86,0,30,0,0,0,217,0,147,0,55,0,63,0,61,0,104,0,115,0,199,0,201,0,167,0,79,0,203,0,0,0,12,0,253,0,184,0,0,0,203,0,18,0,47,0,163,0,0,0,87,0,81,0,21,0,250,0,125,0,118,0,70,0,133,0,0,0,0,0,150,0,0,0,0,0,132,0,0,0,185,0,139,0,111,0,10,0,0,0,149,0,54,0,10,0,68,0,220,0,82,0,90,0,26,0,37,0,104,0,107,0,67,0,232,0,13,0,60,0,224,0,0,0,0,0,95,0,119,0,73,0,109,0,0,0,95,0,195,0,77,0,119,0,75,0,134,0,19,0,138,0,100,0,216,0,32,0,59,0,96,0,92,0,230,0,28,0,232,0,193,0,210,0,66,0,144,0,0,0,0,0,248,0,29,0,193,0,105,0,226,0,0,0,13,0,237,0,158,0,229,0,111,0,19,0,221,0,63,0,26,0,0,0,0,0,215,0,211,0,28,0,71,0,184,0,202,0,195,0,141,0,139,0,218,0,124,0,240,0,90,0,252,0,0,0,162,0,0,0,123,0,59,0,173,0,70,0,178,0,159,0,0,0,188,0,6,0,75,0,255,0,0,0,33,0,149,0,187,0,61,0);
signal scenario_full  : scenario_type := (0,0,2,31,188,31,188,30,145,31,108,31,150,31,177,31,194,31,194,30,100,31,139,31,4,31,250,31,250,30,110,31,110,30,121,31,79,31,79,30,12,31,134,31,198,31,87,31,87,30,87,29,152,31,152,30,168,31,71,31,241,31,112,31,31,31,113,31,54,31,6,31,121,31,14,31,14,30,234,31,210,31,92,31,92,30,254,31,168,31,47,31,218,31,197,31,53,31,53,30,53,29,184,31,202,31,144,31,65,31,255,31,214,31,148,31,183,31,164,31,191,31,249,31,101,31,197,31,90,31,218,31,237,31,218,31,218,30,218,29,218,31,218,31,51,31,193,31,255,31,14,31,168,31,60,31,66,31,161,31,127,31,234,31,45,31,51,31,51,30,103,31,231,31,141,31,160,31,160,30,40,31,252,31,252,30,252,29,33,31,36,31,91,31,25,31,81,31,34,31,49,31,217,31,217,30,221,31,95,31,86,31,86,30,104,31,214,31,206,31,207,31,211,31,190,31,99,31,99,30,170,31,100,31,183,31,167,31,201,31,201,30,227,31,109,31,13,31,65,31,89,31,112,31,8,31,249,31,61,31,44,31,44,30,132,31,242,31,180,31,142,31,52,31,184,31,87,31,231,31,231,30,72,31,106,31,140,31,62,31,62,30,62,29,88,31,32,31,32,30,247,31,164,31,248,31,9,31,9,30,14,31,123,31,123,30,180,31,173,31,250,31,250,30,83,31,83,30,72,31,72,30,162,31,162,30,62,31,62,30,195,31,61,31,141,31,141,30,99,31,99,30,237,31,222,31,132,31,47,31,57,31,83,31,229,31,229,30,159,31,103,31,163,31,108,31,225,31,47,31,48,31,249,31,1,31,36,31,123,31,59,31,80,31,58,31,44,31,197,31,26,31,77,31,103,31,103,30,33,31,33,30,162,31,27,31,108,31,31,31,31,30,132,31,132,30,132,29,132,28,176,31,163,31,71,31,165,31,68,31,186,31,50,31,34,31,142,31,69,31,69,30,89,31,188,31,144,31,39,31,39,30,212,31,174,31,187,31,179,31,220,31,220,30,120,31,200,31,8,31,231,31,135,31,209,31,141,31,191,31,164,31,129,31,47,31,207,31,196,31,32,31,54,31,170,31,214,31,214,30,140,31,21,31,21,30,33,31,255,31,255,30,156,31,163,31,26,31,132,31,231,31,231,30,244,31,75,31,75,30,131,31,57,31,13,31,36,31,36,30,63,31,227,31,227,30,213,31,80,31,80,30,84,31,84,30,75,31,23,31,64,31,192,31,103,31,191,31,248,31,248,30,200,31,33,31,33,30,14,31,133,31,9,31,209,31,209,30,139,31,158,31,93,31,93,30,120,31,154,31,214,31,143,31,142,31,142,31,194,31,240,31,35,31,35,30,239,31,89,31,240,31,96,31,22,31,184,31,184,30,105,31,105,30,143,31,141,31,96,31,140,31,46,31,8,31,35,31,216,31,210,31,137,31,118,31,220,31,53,31,175,31,255,31,93,31,241,31,241,30,241,31,172,31,35,31,35,30,56,31,254,31,13,31,73,31,42,31,229,31,106,31,242,31,183,31,183,30,22,31,200,31,23,31,92,31,92,30,212,31,243,31,37,31,214,31,233,31,30,31,101,31,101,30,101,29,18,31,161,31,112,31,205,31,35,31,102,31,31,31,158,31,158,30,230,31,87,31,229,31,99,31,198,31,252,31,7,31,216,31,57,31,55,31,69,31,130,31,129,31,203,31,50,31,6,31,224,31,8,31,158,31,158,30,103,31,103,30,103,29,224,31,155,31,199,31,153,31,118,31,197,31,195,31,83,31,154,31,200,31,200,30,42,31,42,30,42,29,24,31,249,31,249,30,96,31,96,30,96,29,121,31,179,31,27,31,209,31,23,31,154,31,30,31,125,31,125,30,124,31,78,31,78,30,177,31,32,31,62,31,137,31,137,30,34,31,72,31,176,31,176,30,154,31,183,31,152,31,196,31,40,31,10,31,202,31,205,31,219,31,45,31,93,31,86,31,30,31,30,30,217,31,147,31,55,31,63,31,61,31,104,31,115,31,199,31,201,31,167,31,79,31,203,31,203,30,12,31,253,31,184,31,184,30,203,31,18,31,47,31,163,31,163,30,87,31,81,31,21,31,250,31,125,31,118,31,70,31,133,31,133,30,133,29,150,31,150,30,150,29,132,31,132,30,185,31,139,31,111,31,10,31,10,30,149,31,54,31,10,31,68,31,220,31,82,31,90,31,26,31,37,31,104,31,107,31,67,31,232,31,13,31,60,31,224,31,224,30,224,29,95,31,119,31,73,31,109,31,109,30,95,31,195,31,77,31,119,31,75,31,134,31,19,31,138,31,100,31,216,31,32,31,59,31,96,31,92,31,230,31,28,31,232,31,193,31,210,31,66,31,144,31,144,30,144,29,248,31,29,31,193,31,105,31,226,31,226,30,13,31,237,31,158,31,229,31,111,31,19,31,221,31,63,31,26,31,26,30,26,29,215,31,211,31,28,31,71,31,184,31,202,31,195,31,141,31,139,31,218,31,124,31,240,31,90,31,252,31,252,30,162,31,162,30,123,31,59,31,173,31,70,31,178,31,159,31,159,30,188,31,6,31,75,31,255,31,255,30,33,31,149,31,187,31,61,31);

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
