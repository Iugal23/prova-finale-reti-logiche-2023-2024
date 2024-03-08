-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_641 is
end project_tb_641;

architecture project_tb_arch_641 of project_tb_641 is
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

constant SCENARIO_LENGTH : integer := 617;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,250,0,53,0,15,0,163,0,27,0,206,0,251,0,154,0,0,0,0,0,206,0,0,0,37,0,169,0,21,0,29,0,244,0,102,0,177,0,195,0,0,0,69,0,23,0,239,0,0,0,6,0,107,0,0,0,63,0,138,0,37,0,34,0,0,0,0,0,179,0,8,0,241,0,54,0,0,0,77,0,48,0,217,0,214,0,39,0,0,0,255,0,214,0,242,0,174,0,30,0,54,0,112,0,24,0,41,0,207,0,0,0,144,0,157,0,224,0,184,0,109,0,198,0,158,0,0,0,0,0,0,0,254,0,168,0,198,0,22,0,232,0,202,0,24,0,62,0,196,0,40,0,240,0,165,0,138,0,0,0,89,0,101,0,127,0,170,0,18,0,4,0,0,0,0,0,190,0,57,0,235,0,0,0,0,0,240,0,0,0,209,0,58,0,101,0,40,0,0,0,146,0,118,0,111,0,11,0,50,0,206,0,0,0,0,0,46,0,157,0,59,0,248,0,0,0,114,0,0,0,146,0,90,0,0,0,175,0,238,0,126,0,0,0,32,0,0,0,63,0,0,0,37,0,97,0,103,0,166,0,39,0,0,0,20,0,0,0,146,0,82,0,190,0,122,0,25,0,216,0,0,0,32,0,250,0,85,0,250,0,1,0,27,0,0,0,0,0,55,0,130,0,129,0,25,0,133,0,0,0,121,0,188,0,160,0,0,0,187,0,142,0,241,0,158,0,97,0,33,0,73,0,62,0,81,0,68,0,15,0,34,0,7,0,0,0,194,0,7,0,158,0,64,0,97,0,0,0,198,0,43,0,70,0,74,0,209,0,50,0,45,0,118,0,61,0,0,0,218,0,49,0,0,0,222,0,150,0,0,0,157,0,144,0,0,0,156,0,167,0,0,0,48,0,7,0,121,0,160,0,199,0,140,0,255,0,0,0,176,0,0,0,0,0,134,0,0,0,201,0,56,0,159,0,101,0,21,0,214,0,190,0,163,0,0,0,240,0,0,0,189,0,10,0,0,0,168,0,140,0,166,0,135,0,44,0,194,0,205,0,169,0,72,0,82,0,70,0,69,0,114,0,0,0,134,0,109,0,20,0,220,0,27,0,7,0,34,0,68,0,156,0,91,0,0,0,70,0,102,0,0,0,47,0,7,0,0,0,0,0,206,0,24,0,128,0,140,0,58,0,106,0,112,0,213,0,0,0,131,0,78,0,205,0,254,0,53,0,221,0,247,0,184,0,0,0,167,0,0,0,0,0,191,0,175,0,7,0,112,0,71,0,172,0,36,0,117,0,224,0,227,0,217,0,4,0,113,0,212,0,0,0,137,0,174,0,205,0,71,0,209,0,0,0,96,0,0,0,30,0,214,0,88,0,233,0,0,0,35,0,222,0,54,0,0,0,111,0,170,0,0,0,1,0,77,0,0,0,147,0,14,0,31,0,32,0,249,0,188,0,0,0,46,0,0,0,156,0,69,0,65,0,245,0,10,0,85,0,198,0,207,0,0,0,246,0,189,0,232,0,45,0,168,0,183,0,148,0,0,0,58,0,0,0,237,0,167,0,231,0,26,0,185,0,218,0,37,0,59,0,223,0,145,0,88,0,104,0,208,0,103,0,204,0,77,0,0,0,97,0,0,0,144,0,233,0,54,0,0,0,123,0,0,0,146,0,13,0,9,0,99,0,0,0,166,0,102,0,249,0,22,0,138,0,0,0,0,0,0,0,39,0,251,0,0,0,101,0,169,0,254,0,0,0,158,0,0,0,115,0,117,0,0,0,0,0,0,0,186,0,78,0,0,0,0,0,127,0,60,0,41,0,156,0,226,0,201,0,168,0,172,0,179,0,60,0,211,0,85,0,150,0,0,0,192,0,42,0,0,0,113,0,205,0,167,0,90,0,0,0,0,0,233,0,151,0,139,0,0,0,164,0,12,0,0,0,0,0,64,0,198,0,28,0,182,0,0,0,162,0,72,0,164,0,0,0,107,0,174,0,211,0,59,0,0,0,187,0,143,0,0,0,0,0,0,0,87,0,10,0,14,0,102,0,196,0,210,0,113,0,132,0,151,0,12,0,187,0,153,0,185,0,155,0,57,0,110,0,186,0,201,0,107,0,96,0,0,0,0,0,114,0,40,0,251,0,179,0,24,0,247,0,200,0,0,0,19,0,79,0,44,0,179,0,162,0,228,0,115,0,129,0,248,0,6,0,44,0,61,0,182,0,212,0,168,0,233,0,205,0,0,0,156,0,195,0,0,0,125,0,165,0,0,0,43,0,211,0,158,0,88,0,88,0,150,0,185,0,0,0,162,0,0,0,157,0,217,0,126,0,144,0,243,0,137,0,251,0,92,0,46,0,173,0,0,0,102,0,57,0,171,0,44,0,243,0,135,0,32,0,149,0,106,0,0,0,0,0,0,0,169,0,89,0,0,0,146,0,17,0,76,0,0,0,185,0,0,0,0,0,0,0,201,0,64,0,123,0,137,0,220,0,210,0,131,0,208,0,207,0,233,0,195,0,0,0,150,0,160,0,0,0,0,0,0,0,7,0,109,0,137,0,226,0,188,0,44,0,0,0,0,0,7,0,200,0,65,0,33,0,86,0,242,0,77,0,0,0,41,0,0,0,0,0,72,0,10,0,145,0,9,0,138,0,180,0,0,0,100,0,0,0,0,0,4,0,40,0,16,0,0,0,0,0,0,0,240,0,196,0,207,0,83,0,7,0,0,0,207,0,248,0,86,0,178,0,107,0,0,0,176,0);
signal scenario_full  : scenario_type := (0,0,250,31,53,31,15,31,163,31,27,31,206,31,251,31,154,31,154,30,154,29,206,31,206,30,37,31,169,31,21,31,29,31,244,31,102,31,177,31,195,31,195,30,69,31,23,31,239,31,239,30,6,31,107,31,107,30,63,31,138,31,37,31,34,31,34,30,34,29,179,31,8,31,241,31,54,31,54,30,77,31,48,31,217,31,214,31,39,31,39,30,255,31,214,31,242,31,174,31,30,31,54,31,112,31,24,31,41,31,207,31,207,30,144,31,157,31,224,31,184,31,109,31,198,31,158,31,158,30,158,29,158,28,254,31,168,31,198,31,22,31,232,31,202,31,24,31,62,31,196,31,40,31,240,31,165,31,138,31,138,30,89,31,101,31,127,31,170,31,18,31,4,31,4,30,4,29,190,31,57,31,235,31,235,30,235,29,240,31,240,30,209,31,58,31,101,31,40,31,40,30,146,31,118,31,111,31,11,31,50,31,206,31,206,30,206,29,46,31,157,31,59,31,248,31,248,30,114,31,114,30,146,31,90,31,90,30,175,31,238,31,126,31,126,30,32,31,32,30,63,31,63,30,37,31,97,31,103,31,166,31,39,31,39,30,20,31,20,30,146,31,82,31,190,31,122,31,25,31,216,31,216,30,32,31,250,31,85,31,250,31,1,31,27,31,27,30,27,29,55,31,130,31,129,31,25,31,133,31,133,30,121,31,188,31,160,31,160,30,187,31,142,31,241,31,158,31,97,31,33,31,73,31,62,31,81,31,68,31,15,31,34,31,7,31,7,30,194,31,7,31,158,31,64,31,97,31,97,30,198,31,43,31,70,31,74,31,209,31,50,31,45,31,118,31,61,31,61,30,218,31,49,31,49,30,222,31,150,31,150,30,157,31,144,31,144,30,156,31,167,31,167,30,48,31,7,31,121,31,160,31,199,31,140,31,255,31,255,30,176,31,176,30,176,29,134,31,134,30,201,31,56,31,159,31,101,31,21,31,214,31,190,31,163,31,163,30,240,31,240,30,189,31,10,31,10,30,168,31,140,31,166,31,135,31,44,31,194,31,205,31,169,31,72,31,82,31,70,31,69,31,114,31,114,30,134,31,109,31,20,31,220,31,27,31,7,31,34,31,68,31,156,31,91,31,91,30,70,31,102,31,102,30,47,31,7,31,7,30,7,29,206,31,24,31,128,31,140,31,58,31,106,31,112,31,213,31,213,30,131,31,78,31,205,31,254,31,53,31,221,31,247,31,184,31,184,30,167,31,167,30,167,29,191,31,175,31,7,31,112,31,71,31,172,31,36,31,117,31,224,31,227,31,217,31,4,31,113,31,212,31,212,30,137,31,174,31,205,31,71,31,209,31,209,30,96,31,96,30,30,31,214,31,88,31,233,31,233,30,35,31,222,31,54,31,54,30,111,31,170,31,170,30,1,31,77,31,77,30,147,31,14,31,31,31,32,31,249,31,188,31,188,30,46,31,46,30,156,31,69,31,65,31,245,31,10,31,85,31,198,31,207,31,207,30,246,31,189,31,232,31,45,31,168,31,183,31,148,31,148,30,58,31,58,30,237,31,167,31,231,31,26,31,185,31,218,31,37,31,59,31,223,31,145,31,88,31,104,31,208,31,103,31,204,31,77,31,77,30,97,31,97,30,144,31,233,31,54,31,54,30,123,31,123,30,146,31,13,31,9,31,99,31,99,30,166,31,102,31,249,31,22,31,138,31,138,30,138,29,138,28,39,31,251,31,251,30,101,31,169,31,254,31,254,30,158,31,158,30,115,31,117,31,117,30,117,29,117,28,186,31,78,31,78,30,78,29,127,31,60,31,41,31,156,31,226,31,201,31,168,31,172,31,179,31,60,31,211,31,85,31,150,31,150,30,192,31,42,31,42,30,113,31,205,31,167,31,90,31,90,30,90,29,233,31,151,31,139,31,139,30,164,31,12,31,12,30,12,29,64,31,198,31,28,31,182,31,182,30,162,31,72,31,164,31,164,30,107,31,174,31,211,31,59,31,59,30,187,31,143,31,143,30,143,29,143,28,87,31,10,31,14,31,102,31,196,31,210,31,113,31,132,31,151,31,12,31,187,31,153,31,185,31,155,31,57,31,110,31,186,31,201,31,107,31,96,31,96,30,96,29,114,31,40,31,251,31,179,31,24,31,247,31,200,31,200,30,19,31,79,31,44,31,179,31,162,31,228,31,115,31,129,31,248,31,6,31,44,31,61,31,182,31,212,31,168,31,233,31,205,31,205,30,156,31,195,31,195,30,125,31,165,31,165,30,43,31,211,31,158,31,88,31,88,31,150,31,185,31,185,30,162,31,162,30,157,31,217,31,126,31,144,31,243,31,137,31,251,31,92,31,46,31,173,31,173,30,102,31,57,31,171,31,44,31,243,31,135,31,32,31,149,31,106,31,106,30,106,29,106,28,169,31,89,31,89,30,146,31,17,31,76,31,76,30,185,31,185,30,185,29,185,28,201,31,64,31,123,31,137,31,220,31,210,31,131,31,208,31,207,31,233,31,195,31,195,30,150,31,160,31,160,30,160,29,160,28,7,31,109,31,137,31,226,31,188,31,44,31,44,30,44,29,7,31,200,31,65,31,33,31,86,31,242,31,77,31,77,30,41,31,41,30,41,29,72,31,10,31,145,31,9,31,138,31,180,31,180,30,100,31,100,30,100,29,4,31,40,31,16,31,16,30,16,29,16,28,240,31,196,31,207,31,83,31,7,31,7,30,207,31,248,31,86,31,178,31,107,31,107,30,176,31);

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
