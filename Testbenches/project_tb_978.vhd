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

constant SCENARIO_LENGTH : integer := 387;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (102,0,158,0,159,0,113,0,97,0,38,0,108,0,38,0,106,0,0,0,229,0,0,0,189,0,32,0,251,0,0,0,208,0,141,0,203,0,0,0,191,0,0,0,0,0,21,0,111,0,229,0,214,0,127,0,114,0,11,0,0,0,92,0,217,0,79,0,114,0,182,0,125,0,169,0,0,0,49,0,162,0,63,0,199,0,34,0,21,0,67,0,0,0,96,0,121,0,90,0,175,0,0,0,0,0,108,0,52,0,112,0,14,0,119,0,81,0,96,0,11,0,88,0,55,0,93,0,42,0,0,0,176,0,242,0,8,0,192,0,144,0,41,0,45,0,0,0,151,0,74,0,207,0,182,0,42,0,54,0,82,0,250,0,136,0,66,0,19,0,210,0,207,0,67,0,155,0,23,0,210,0,15,0,115,0,0,0,23,0,45,0,150,0,102,0,0,0,0,0,35,0,0,0,66,0,3,0,0,0,37,0,208,0,179,0,217,0,38,0,119,0,0,0,138,0,0,0,0,0,216,0,187,0,0,0,79,0,0,0,0,0,180,0,53,0,175,0,24,0,179,0,245,0,40,0,206,0,74,0,135,0,97,0,165,0,1,0,212,0,135,0,17,0,65,0,211,0,127,0,95,0,83,0,0,0,42,0,249,0,0,0,177,0,37,0,172,0,157,0,50,0,98,0,0,0,107,0,171,0,141,0,0,0,152,0,83,0,70,0,61,0,58,0,243,0,24,0,0,0,54,0,237,0,119,0,117,0,151,0,0,0,70,0,51,0,180,0,86,0,205,0,233,0,254,0,76,0,41,0,44,0,227,0,214,0,167,0,187,0,238,0,240,0,63,0,67,0,0,0,0,0,236,0,0,0,61,0,233,0,0,0,133,0,0,0,0,0,134,0,0,0,38,0,176,0,61,0,244,0,148,0,16,0,101,0,158,0,81,0,90,0,185,0,0,0,188,0,228,0,0,0,90,0,0,0,138,0,6,0,56,0,208,0,0,0,77,0,244,0,0,0,47,0,102,0,101,0,146,0,205,0,149,0,23,0,0,0,201,0,64,0,193,0,0,0,204,0,249,0,65,0,110,0,233,0,0,0,97,0,0,0,0,0,10,0,52,0,184,0,179,0,0,0,125,0,118,0,0,0,0,0,124,0,210,0,56,0,240,0,0,0,102,0,33,0,100,0,154,0,31,0,252,0,227,0,0,0,192,0,114,0,235,0,10,0,13,0,0,0,0,0,75,0,129,0,13,0,10,0,98,0,237,0,0,0,162,0,123,0,254,0,52,0,53,0,2,0,1,0,87,0,134,0,197,0,95,0,236,0,217,0,0,0,203,0,136,0,0,0,0,0,209,0,0,0,168,0,73,0,79,0,117,0,17,0,151,0,55,0,195,0,143,0,155,0,0,0,143,0,0,0,243,0,139,0,165,0,0,0,0,0,229,0,105,0,75,0,178,0,56,0,18,0,103,0,245,0,146,0,0,0,0,0,233,0,195,0,219,0,239,0,235,0,160,0,0,0,0,0,100,0,58,0,165,0,224,0,17,0,0,0,183,0,187,0,0,0,102,0,6,0,166,0,0,0,61,0,149,0,128,0,31,0,43,0,138,0,0,0,57,0,61,0,0,0,32,0,252,0,55,0,0,0,167,0,108,0,34,0,0,0,165,0,0,0,182,0,231,0,125,0,135,0,134,0,104,0,76,0,255,0,220,0,174,0,93,0,62,0,187,0,0,0);
signal scenario_full  : scenario_type := (102,31,158,31,159,31,113,31,97,31,38,31,108,31,38,31,106,31,106,30,229,31,229,30,189,31,32,31,251,31,251,30,208,31,141,31,203,31,203,30,191,31,191,30,191,29,21,31,111,31,229,31,214,31,127,31,114,31,11,31,11,30,92,31,217,31,79,31,114,31,182,31,125,31,169,31,169,30,49,31,162,31,63,31,199,31,34,31,21,31,67,31,67,30,96,31,121,31,90,31,175,31,175,30,175,29,108,31,52,31,112,31,14,31,119,31,81,31,96,31,11,31,88,31,55,31,93,31,42,31,42,30,176,31,242,31,8,31,192,31,144,31,41,31,45,31,45,30,151,31,74,31,207,31,182,31,42,31,54,31,82,31,250,31,136,31,66,31,19,31,210,31,207,31,67,31,155,31,23,31,210,31,15,31,115,31,115,30,23,31,45,31,150,31,102,31,102,30,102,29,35,31,35,30,66,31,3,31,3,30,37,31,208,31,179,31,217,31,38,31,119,31,119,30,138,31,138,30,138,29,216,31,187,31,187,30,79,31,79,30,79,29,180,31,53,31,175,31,24,31,179,31,245,31,40,31,206,31,74,31,135,31,97,31,165,31,1,31,212,31,135,31,17,31,65,31,211,31,127,31,95,31,83,31,83,30,42,31,249,31,249,30,177,31,37,31,172,31,157,31,50,31,98,31,98,30,107,31,171,31,141,31,141,30,152,31,83,31,70,31,61,31,58,31,243,31,24,31,24,30,54,31,237,31,119,31,117,31,151,31,151,30,70,31,51,31,180,31,86,31,205,31,233,31,254,31,76,31,41,31,44,31,227,31,214,31,167,31,187,31,238,31,240,31,63,31,67,31,67,30,67,29,236,31,236,30,61,31,233,31,233,30,133,31,133,30,133,29,134,31,134,30,38,31,176,31,61,31,244,31,148,31,16,31,101,31,158,31,81,31,90,31,185,31,185,30,188,31,228,31,228,30,90,31,90,30,138,31,6,31,56,31,208,31,208,30,77,31,244,31,244,30,47,31,102,31,101,31,146,31,205,31,149,31,23,31,23,30,201,31,64,31,193,31,193,30,204,31,249,31,65,31,110,31,233,31,233,30,97,31,97,30,97,29,10,31,52,31,184,31,179,31,179,30,125,31,118,31,118,30,118,29,124,31,210,31,56,31,240,31,240,30,102,31,33,31,100,31,154,31,31,31,252,31,227,31,227,30,192,31,114,31,235,31,10,31,13,31,13,30,13,29,75,31,129,31,13,31,10,31,98,31,237,31,237,30,162,31,123,31,254,31,52,31,53,31,2,31,1,31,87,31,134,31,197,31,95,31,236,31,217,31,217,30,203,31,136,31,136,30,136,29,209,31,209,30,168,31,73,31,79,31,117,31,17,31,151,31,55,31,195,31,143,31,155,31,155,30,143,31,143,30,243,31,139,31,165,31,165,30,165,29,229,31,105,31,75,31,178,31,56,31,18,31,103,31,245,31,146,31,146,30,146,29,233,31,195,31,219,31,239,31,235,31,160,31,160,30,160,29,100,31,58,31,165,31,224,31,17,31,17,30,183,31,187,31,187,30,102,31,6,31,166,31,166,30,61,31,149,31,128,31,31,31,43,31,138,31,138,30,57,31,61,31,61,30,32,31,252,31,55,31,55,30,167,31,108,31,34,31,34,30,165,31,165,30,182,31,231,31,125,31,135,31,134,31,104,31,76,31,255,31,220,31,174,31,93,31,62,31,187,31,187,30);

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
