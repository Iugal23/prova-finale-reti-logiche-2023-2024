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

constant SCENARIO_LENGTH : integer := 474;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (147,0,196,0,239,0,65,0,96,0,149,0,0,0,0,0,218,0,3,0,168,0,0,0,137,0,102,0,113,0,89,0,7,0,26,0,190,0,53,0,24,0,0,0,95,0,26,0,249,0,159,0,153,0,113,0,102,0,153,0,172,0,15,0,244,0,174,0,199,0,0,0,0,0,180,0,0,0,179,0,201,0,0,0,189,0,5,0,142,0,125,0,239,0,0,0,72,0,135,0,84,0,0,0,92,0,27,0,0,0,57,0,184,0,125,0,249,0,241,0,208,0,192,0,41,0,94,0,3,0,0,0,205,0,69,0,24,0,211,0,76,0,15,0,106,0,0,0,84,0,129,0,58,0,0,0,160,0,141,0,29,0,92,0,217,0,51,0,86,0,232,0,107,0,238,0,0,0,223,0,0,0,129,0,28,0,62,0,74,0,248,0,216,0,240,0,134,0,161,0,229,0,154,0,108,0,54,0,0,0,0,0,196,0,0,0,0,0,57,0,223,0,63,0,152,0,156,0,183,0,165,0,76,0,214,0,87,0,0,0,159,0,3,0,180,0,0,0,110,0,0,0,200,0,63,0,0,0,0,0,5,0,127,0,184,0,124,0,0,0,67,0,254,0,162,0,128,0,81,0,10,0,205,0,0,0,99,0,23,0,43,0,143,0,83,0,0,0,73,0,189,0,113,0,35,0,0,0,148,0,187,0,56,0,0,0,200,0,4,0,0,0,246,0,202,0,0,0,200,0,116,0,93,0,78,0,21,0,65,0,0,0,252,0,218,0,163,0,29,0,0,0,0,0,81,0,0,0,49,0,196,0,61,0,28,0,77,0,0,0,8,0,189,0,240,0,0,0,139,0,0,0,76,0,0,0,63,0,157,0,127,0,0,0,139,0,105,0,227,0,0,0,192,0,213,0,0,0,130,0,37,0,125,0,56,0,0,0,202,0,0,0,240,0,244,0,10,0,203,0,236,0,242,0,73,0,0,0,91,0,0,0,210,0,0,0,8,0,84,0,7,0,30,0,210,0,0,0,79,0,119,0,34,0,0,0,220,0,229,0,130,0,251,0,55,0,229,0,222,0,95,0,240,0,141,0,0,0,90,0,0,0,106,0,193,0,158,0,224,0,0,0,79,0,173,0,65,0,177,0,142,0,7,0,0,0,54,0,49,0,78,0,148,0,0,0,175,0,185,0,134,0,216,0,224,0,72,0,2,0,8,0,113,0,241,0,207,0,162,0,28,0,66,0,0,0,145,0,250,0,144,0,58,0,148,0,116,0,203,0,78,0,50,0,0,0,0,0,0,0,141,0,0,0,39,0,160,0,17,0,79,0,102,0,149,0,187,0,72,0,170,0,124,0,209,0,179,0,81,0,140,0,18,0,98,0,105,0,38,0,163,0,91,0,170,0,0,0,0,0,0,0,214,0,175,0,227,0,65,0,86,0,158,0,240,0,216,0,214,0,166,0,199,0,116,0,82,0,0,0,112,0,48,0,0,0,60,0,131,0,35,0,45,0,169,0,124,0,0,0,231,0,158,0,0,0,87,0,46,0,57,0,115,0,174,0,126,0,153,0,84,0,91,0,215,0,170,0,198,0,0,0,72,0,239,0,57,0,247,0,187,0,0,0,24,0,186,0,183,0,0,0,124,0,51,0,0,0,0,0,86,0,213,0,107,0,27,0,192,0,0,0,27,0,81,0,224,0,72,0,238,0,235,0,223,0,234,0,117,0,0,0,183,0,0,0,197,0,143,0,0,0,63,0,87,0,0,0,55,0,131,0,239,0,19,0,108,0,236,0,224,0,0,0,198,0,143,0,254,0,154,0,30,0,208,0,207,0,103,0,123,0,49,0,86,0,166,0,234,0,22,0,125,0,232,0,23,0,212,0,157,0,39,0,232,0,108,0,0,0,219,0,225,0,0,0,112,0,17,0,60,0,93,0,124,0,0,0,174,0,0,0,63,0,0,0,0,0,14,0,0,0,10,0,0,0,0,0,233,0,147,0,196,0,223,0,192,0,0,0,254,0,61,0,147,0,158,0,244,0,211,0,83,0,179,0,166,0,57,0,248,0,0,0,34,0,0,0,12,0,13,0,223,0,134,0,148,0,0,0,249,0,20,0,83,0,31,0);
signal scenario_full  : scenario_type := (147,31,196,31,239,31,65,31,96,31,149,31,149,30,149,29,218,31,3,31,168,31,168,30,137,31,102,31,113,31,89,31,7,31,26,31,190,31,53,31,24,31,24,30,95,31,26,31,249,31,159,31,153,31,113,31,102,31,153,31,172,31,15,31,244,31,174,31,199,31,199,30,199,29,180,31,180,30,179,31,201,31,201,30,189,31,5,31,142,31,125,31,239,31,239,30,72,31,135,31,84,31,84,30,92,31,27,31,27,30,57,31,184,31,125,31,249,31,241,31,208,31,192,31,41,31,94,31,3,31,3,30,205,31,69,31,24,31,211,31,76,31,15,31,106,31,106,30,84,31,129,31,58,31,58,30,160,31,141,31,29,31,92,31,217,31,51,31,86,31,232,31,107,31,238,31,238,30,223,31,223,30,129,31,28,31,62,31,74,31,248,31,216,31,240,31,134,31,161,31,229,31,154,31,108,31,54,31,54,30,54,29,196,31,196,30,196,29,57,31,223,31,63,31,152,31,156,31,183,31,165,31,76,31,214,31,87,31,87,30,159,31,3,31,180,31,180,30,110,31,110,30,200,31,63,31,63,30,63,29,5,31,127,31,184,31,124,31,124,30,67,31,254,31,162,31,128,31,81,31,10,31,205,31,205,30,99,31,23,31,43,31,143,31,83,31,83,30,73,31,189,31,113,31,35,31,35,30,148,31,187,31,56,31,56,30,200,31,4,31,4,30,246,31,202,31,202,30,200,31,116,31,93,31,78,31,21,31,65,31,65,30,252,31,218,31,163,31,29,31,29,30,29,29,81,31,81,30,49,31,196,31,61,31,28,31,77,31,77,30,8,31,189,31,240,31,240,30,139,31,139,30,76,31,76,30,63,31,157,31,127,31,127,30,139,31,105,31,227,31,227,30,192,31,213,31,213,30,130,31,37,31,125,31,56,31,56,30,202,31,202,30,240,31,244,31,10,31,203,31,236,31,242,31,73,31,73,30,91,31,91,30,210,31,210,30,8,31,84,31,7,31,30,31,210,31,210,30,79,31,119,31,34,31,34,30,220,31,229,31,130,31,251,31,55,31,229,31,222,31,95,31,240,31,141,31,141,30,90,31,90,30,106,31,193,31,158,31,224,31,224,30,79,31,173,31,65,31,177,31,142,31,7,31,7,30,54,31,49,31,78,31,148,31,148,30,175,31,185,31,134,31,216,31,224,31,72,31,2,31,8,31,113,31,241,31,207,31,162,31,28,31,66,31,66,30,145,31,250,31,144,31,58,31,148,31,116,31,203,31,78,31,50,31,50,30,50,29,50,28,141,31,141,30,39,31,160,31,17,31,79,31,102,31,149,31,187,31,72,31,170,31,124,31,209,31,179,31,81,31,140,31,18,31,98,31,105,31,38,31,163,31,91,31,170,31,170,30,170,29,170,28,214,31,175,31,227,31,65,31,86,31,158,31,240,31,216,31,214,31,166,31,199,31,116,31,82,31,82,30,112,31,48,31,48,30,60,31,131,31,35,31,45,31,169,31,124,31,124,30,231,31,158,31,158,30,87,31,46,31,57,31,115,31,174,31,126,31,153,31,84,31,91,31,215,31,170,31,198,31,198,30,72,31,239,31,57,31,247,31,187,31,187,30,24,31,186,31,183,31,183,30,124,31,51,31,51,30,51,29,86,31,213,31,107,31,27,31,192,31,192,30,27,31,81,31,224,31,72,31,238,31,235,31,223,31,234,31,117,31,117,30,183,31,183,30,197,31,143,31,143,30,63,31,87,31,87,30,55,31,131,31,239,31,19,31,108,31,236,31,224,31,224,30,198,31,143,31,254,31,154,31,30,31,208,31,207,31,103,31,123,31,49,31,86,31,166,31,234,31,22,31,125,31,232,31,23,31,212,31,157,31,39,31,232,31,108,31,108,30,219,31,225,31,225,30,112,31,17,31,60,31,93,31,124,31,124,30,174,31,174,30,63,31,63,30,63,29,14,31,14,30,10,31,10,30,10,29,233,31,147,31,196,31,223,31,192,31,192,30,254,31,61,31,147,31,158,31,244,31,211,31,83,31,179,31,166,31,57,31,248,31,248,30,34,31,34,30,12,31,13,31,223,31,134,31,148,31,148,30,249,31,20,31,83,31,31,31);

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
