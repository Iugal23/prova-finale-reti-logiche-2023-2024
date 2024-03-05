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

constant SCENARIO_LENGTH : integer := 594;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (176,0,129,0,224,0,123,0,190,0,0,0,0,0,170,0,0,0,0,0,0,0,196,0,10,0,71,0,0,0,194,0,143,0,76,0,0,0,36,0,96,0,154,0,82,0,44,0,0,0,0,0,0,0,201,0,0,0,97,0,0,0,164,0,0,0,149,0,164,0,107,0,92,0,249,0,97,0,90,0,169,0,217,0,72,0,0,0,22,0,0,0,47,0,99,0,147,0,0,0,157,0,201,0,66,0,0,0,142,0,31,0,17,0,74,0,193,0,0,0,90,0,72,0,87,0,0,0,73,0,0,0,134,0,168,0,0,0,0,0,231,0,208,0,159,0,0,0,100,0,152,0,224,0,30,0,13,0,241,0,130,0,251,0,205,0,105,0,0,0,104,0,46,0,145,0,71,0,0,0,133,0,255,0,0,0,207,0,0,0,79,0,203,0,0,0,99,0,0,0,10,0,0,0,0,0,20,0,84,0,0,0,178,0,0,0,2,0,184,0,25,0,184,0,93,0,59,0,160,0,195,0,0,0,16,0,0,0,0,0,91,0,8,0,0,0,52,0,71,0,38,0,0,0,172,0,228,0,89,0,82,0,0,0,117,0,82,0,111,0,0,0,159,0,66,0,241,0,5,0,68,0,0,0,214,0,28,0,249,0,139,0,209,0,146,0,96,0,32,0,0,0,14,0,157,0,128,0,0,0,77,0,0,0,108,0,0,0,30,0,165,0,197,0,68,0,59,0,161,0,248,0,64,0,0,0,0,0,94,0,0,0,0,0,77,0,0,0,0,0,43,0,117,0,106,0,133,0,208,0,188,0,119,0,221,0,15,0,131,0,0,0,113,0,216,0,0,0,42,0,0,0,231,0,28,0,0,0,56,0,200,0,64,0,242,0,28,0,191,0,240,0,215,0,126,0,126,0,182,0,7,0,2,0,221,0,175,0,77,0,92,0,51,0,237,0,163,0,147,0,237,0,20,0,110,0,4,0,0,0,177,0,190,0,22,0,24,0,0,0,0,0,0,0,71,0,213,0,215,0,137,0,149,0,208,0,213,0,54,0,80,0,239,0,93,0,143,0,207,0,210,0,59,0,139,0,0,0,0,0,0,0,160,0,32,0,0,0,33,0,213,0,161,0,11,0,96,0,28,0,254,0,47,0,0,0,164,0,135,0,66,0,0,0,171,0,207,0,103,0,108,0,111,0,198,0,117,0,2,0,94,0,28,0,110,0,17,0,223,0,18,0,183,0,0,0,148,0,0,0,154,0,201,0,37,0,194,0,0,0,115,0,0,0,0,0,123,0,94,0,0,0,175,0,178,0,186,0,116,0,0,0,121,0,226,0,117,0,0,0,208,0,0,0,0,0,0,0,51,0,204,0,40,0,0,0,202,0,213,0,0,0,252,0,0,0,222,0,77,0,174,0,0,0,9,0,229,0,103,0,0,0,137,0,0,0,0,0,97,0,29,0,111,0,59,0,182,0,128,0,167,0,92,0,11,0,0,0,55,0,236,0,50,0,190,0,73,0,107,0,0,0,184,0,59,0,48,0,102,0,195,0,19,0,189,0,121,0,197,0,168,0,44,0,155,0,0,0,24,0,17,0,19,0,111,0,231,0,86,0,173,0,172,0,119,0,211,0,223,0,124,0,183,0,132,0,0,0,174,0,78,0,230,0,131,0,32,0,21,0,64,0,12,0,176,0,97,0,170,0,230,0,8,0,0,0,0,0,247,0,42,0,50,0,133,0,207,0,110,0,60,0,232,0,192,0,0,0,90,0,114,0,239,0,136,0,179,0,58,0,179,0,110,0,37,0,84,0,0,0,0,0,26,0,0,0,99,0,44,0,61,0,80,0,131,0,0,0,246,0,98,0,29,0,172,0,92,0,114,0,197,0,0,0,88,0,0,0,117,0,19,0,209,0,48,0,25,0,57,0,163,0,211,0,46,0,73,0,220,0,94,0,111,0,0,0,12,0,179,0,198,0,194,0,218,0,72,0,165,0,110,0,11,0,60,0,237,0,20,0,52,0,213,0,93,0,6,0,92,0,0,0,113,0,193,0,54,0,0,0,0,0,255,0,162,0,154,0,0,0,0,0,0,0,30,0,15,0,198,0,42,0,95,0,119,0,0,0,116,0,20,0,0,0,89,0,182,0,69,0,183,0,0,0,223,0,64,0,176,0,195,0,0,0,0,0,8,0,0,0,54,0,89,0,0,0,0,0,130,0,135,0,224,0,223,0,0,0,22,0,105,0,240,0,91,0,34,0,247,0,153,0,47,0,149,0,216,0,52,0,0,0,227,0,199,0,150,0,68,0,0,0,179,0,8,0,58,0,161,0,0,0,0,0,0,0,52,0,112,0,79,0,84,0,0,0,222,0,245,0,135,0,153,0,0,0,210,0,0,0,0,0,15,0,223,0,247,0,0,0,12,0,81,0,58,0,188,0,47,0,62,0,140,0,200,0,166,0,48,0,12,0,217,0,173,0,214,0,48,0,0,0,0,0,85,0,44,0,195,0,123,0,13,0,0,0,165,0,116,0,207,0,8,0,229,0,0,0,170,0,211,0,209,0,24,0,0,0,0,0,113,0,104,0,0,0,253,0,67,0,133,0,163,0,0,0,112,0,130,0,18,0,77,0,0,0,244,0,249,0,208,0,0,0,0,0,183,0);
signal scenario_full  : scenario_type := (176,31,129,31,224,31,123,31,190,31,190,30,190,29,170,31,170,30,170,29,170,28,196,31,10,31,71,31,71,30,194,31,143,31,76,31,76,30,36,31,96,31,154,31,82,31,44,31,44,30,44,29,44,28,201,31,201,30,97,31,97,30,164,31,164,30,149,31,164,31,107,31,92,31,249,31,97,31,90,31,169,31,217,31,72,31,72,30,22,31,22,30,47,31,99,31,147,31,147,30,157,31,201,31,66,31,66,30,142,31,31,31,17,31,74,31,193,31,193,30,90,31,72,31,87,31,87,30,73,31,73,30,134,31,168,31,168,30,168,29,231,31,208,31,159,31,159,30,100,31,152,31,224,31,30,31,13,31,241,31,130,31,251,31,205,31,105,31,105,30,104,31,46,31,145,31,71,31,71,30,133,31,255,31,255,30,207,31,207,30,79,31,203,31,203,30,99,31,99,30,10,31,10,30,10,29,20,31,84,31,84,30,178,31,178,30,2,31,184,31,25,31,184,31,93,31,59,31,160,31,195,31,195,30,16,31,16,30,16,29,91,31,8,31,8,30,52,31,71,31,38,31,38,30,172,31,228,31,89,31,82,31,82,30,117,31,82,31,111,31,111,30,159,31,66,31,241,31,5,31,68,31,68,30,214,31,28,31,249,31,139,31,209,31,146,31,96,31,32,31,32,30,14,31,157,31,128,31,128,30,77,31,77,30,108,31,108,30,30,31,165,31,197,31,68,31,59,31,161,31,248,31,64,31,64,30,64,29,94,31,94,30,94,29,77,31,77,30,77,29,43,31,117,31,106,31,133,31,208,31,188,31,119,31,221,31,15,31,131,31,131,30,113,31,216,31,216,30,42,31,42,30,231,31,28,31,28,30,56,31,200,31,64,31,242,31,28,31,191,31,240,31,215,31,126,31,126,31,182,31,7,31,2,31,221,31,175,31,77,31,92,31,51,31,237,31,163,31,147,31,237,31,20,31,110,31,4,31,4,30,177,31,190,31,22,31,24,31,24,30,24,29,24,28,71,31,213,31,215,31,137,31,149,31,208,31,213,31,54,31,80,31,239,31,93,31,143,31,207,31,210,31,59,31,139,31,139,30,139,29,139,28,160,31,32,31,32,30,33,31,213,31,161,31,11,31,96,31,28,31,254,31,47,31,47,30,164,31,135,31,66,31,66,30,171,31,207,31,103,31,108,31,111,31,198,31,117,31,2,31,94,31,28,31,110,31,17,31,223,31,18,31,183,31,183,30,148,31,148,30,154,31,201,31,37,31,194,31,194,30,115,31,115,30,115,29,123,31,94,31,94,30,175,31,178,31,186,31,116,31,116,30,121,31,226,31,117,31,117,30,208,31,208,30,208,29,208,28,51,31,204,31,40,31,40,30,202,31,213,31,213,30,252,31,252,30,222,31,77,31,174,31,174,30,9,31,229,31,103,31,103,30,137,31,137,30,137,29,97,31,29,31,111,31,59,31,182,31,128,31,167,31,92,31,11,31,11,30,55,31,236,31,50,31,190,31,73,31,107,31,107,30,184,31,59,31,48,31,102,31,195,31,19,31,189,31,121,31,197,31,168,31,44,31,155,31,155,30,24,31,17,31,19,31,111,31,231,31,86,31,173,31,172,31,119,31,211,31,223,31,124,31,183,31,132,31,132,30,174,31,78,31,230,31,131,31,32,31,21,31,64,31,12,31,176,31,97,31,170,31,230,31,8,31,8,30,8,29,247,31,42,31,50,31,133,31,207,31,110,31,60,31,232,31,192,31,192,30,90,31,114,31,239,31,136,31,179,31,58,31,179,31,110,31,37,31,84,31,84,30,84,29,26,31,26,30,99,31,44,31,61,31,80,31,131,31,131,30,246,31,98,31,29,31,172,31,92,31,114,31,197,31,197,30,88,31,88,30,117,31,19,31,209,31,48,31,25,31,57,31,163,31,211,31,46,31,73,31,220,31,94,31,111,31,111,30,12,31,179,31,198,31,194,31,218,31,72,31,165,31,110,31,11,31,60,31,237,31,20,31,52,31,213,31,93,31,6,31,92,31,92,30,113,31,193,31,54,31,54,30,54,29,255,31,162,31,154,31,154,30,154,29,154,28,30,31,15,31,198,31,42,31,95,31,119,31,119,30,116,31,20,31,20,30,89,31,182,31,69,31,183,31,183,30,223,31,64,31,176,31,195,31,195,30,195,29,8,31,8,30,54,31,89,31,89,30,89,29,130,31,135,31,224,31,223,31,223,30,22,31,105,31,240,31,91,31,34,31,247,31,153,31,47,31,149,31,216,31,52,31,52,30,227,31,199,31,150,31,68,31,68,30,179,31,8,31,58,31,161,31,161,30,161,29,161,28,52,31,112,31,79,31,84,31,84,30,222,31,245,31,135,31,153,31,153,30,210,31,210,30,210,29,15,31,223,31,247,31,247,30,12,31,81,31,58,31,188,31,47,31,62,31,140,31,200,31,166,31,48,31,12,31,217,31,173,31,214,31,48,31,48,30,48,29,85,31,44,31,195,31,123,31,13,31,13,30,165,31,116,31,207,31,8,31,229,31,229,30,170,31,211,31,209,31,24,31,24,30,24,29,113,31,104,31,104,30,253,31,67,31,133,31,163,31,163,30,112,31,130,31,18,31,77,31,77,30,244,31,249,31,208,31,208,30,208,29,183,31);

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
